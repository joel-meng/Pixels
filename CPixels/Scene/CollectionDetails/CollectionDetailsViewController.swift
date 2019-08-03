//
//  CollectionDetailsViewController.swift
//  CPixels
//
//  Created by Joel Meng on 7/29/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import UIKit
import CollectionKit
import ReSwift
import ReSwiftRouter

final class CollectionDetailsViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet var collectionView: CollectionView!

	// MARK: - Selections

	var featuredCollection: UnsplashCollection?

	private var photoURLs: [String]?

	// MARK: - States

	private var collectionProvider: BasicProvider<UIImage, UIImageView>?

	// MARK: - Lifecycles

	override func viewDidLoad() {
        super.viewDidLoad()

		title = featuredCollection?.title ?? "Previews"

		subscribePhotoStateSkippingRepeats()

		configCollectionView(collectionView)
    }

	override func didMove(toParent parent: UIViewController?) {
		if nil == parent {
			store.dispatch(SetRouteAction([mainViewRoute]))
		}
	}

	deinit {
		unsubscribePhotoState()
	}

	// MARK: - UI configuration

	private func configCollectionView(_ collectionView: CollectionView) {

		let viewSource = ClosureViewSource { (imageView: UIImageView, data: UIImage, index: Int) in
			imageView.contentMode = .scaleAspectFit
			imageView.image = data
			imageView.layer.cornerRadius = 6
			imageView.clipsToBounds = true
		}

		let sizeSource = { (index: Int, data: UIImage, collectionSize: CGSize) -> CGSize in
			let ratio = data.size.width / data.size.height
			let cellWidth = collectionSize.width
			let cellHeight = cellWidth / ratio
			return CGSize(width: cellWidth, height: cellHeight)
		}

		let provider = BasicProvider(dataSource: [UIImage](),
									 viewSource: viewSource,
									 sizeSource: sizeSource)

		provider.layout = WaterfallLayout(columns: 2, spacing: 5)
		collectionView.provider = provider
		self.collectionProvider = provider
	}
}

extension CollectionDetailsViewController: StoreSubscriber {

	func newState(
		state: (selectedCollection: UnsplashCollection?,
				sceneState: CollectionPhotosSceneState,
				photoState: PhotoLoadingState)) {

		if featuredCollection == nil, let selectedCollection = state.selectedCollection {
			featuredCollection = state.selectedCollection
			store.dispatch(fetchCollectionPhotos(collectionID: selectedCollection.id!, photosPerPage: 20))
			return
		}

		if photoURLs == nil {

			if case let .ready(photos) = state.sceneState.collectionPhotos {

				let thumURLs = photos.compactMap { photo -> String? in
					photo.urls?.thumb
				}
				self.photoURLs = thumURLs

				displayLoadedImages(loadedImages(forCollectionImageURLs: thumURLs,
												 from: state.photoState.loaded))

				dispatchUnloadedImage(forCollectionImageURLs: thumURLs,
									  from: state.photoState.loaded)
			}
			return
		}

		displayLoadedImages(loadedImages(forCollectionImageURLs: photoURLs!,
										 from: state.photoState.loaded))

		dispatchUnloadedImage(forCollectionImageURLs: photoURLs!,
							  from: state.photoState.loaded)
	}

	private func loadedImages(forCollectionImageURLs collectionImageURLs: [String],
							  from imageCache: [String: UIImage]) -> [UIImage] {
		let loadedPhotoSet = Set(imageCache.keys)
		let collectionPhotoSet = Set(collectionImageURLs)
		let loadedCollectionPhotoSet = collectionPhotoSet.intersection(loadedPhotoSet)

		return Array(imageCache.filter { (url, image) -> Bool in
			loadedCollectionPhotoSet.contains(url)
		}.values)
	}

	private func dispatchUnloadedImage(forCollectionImageURLs collectionImageURLs: [String],
									   from imageCache: [String: UIImage]) {
		let loadedPhotoSet = Set(imageCache.keys)
		let collectionPhotoSet = Set(collectionImageURLs)
		collectionPhotoSet.subtracting(loadedPhotoSet).forEach({ (url) in
			store.dispatch(fetchImage(withURL: url))
		})
	}

	private func displayLoadedImages(_ images: [UIImage]) {
		DispatchQueue.main.async { [weak self] in
			self?.collectionProvider?.dataSource = ArrayDataSource(data: images)
		}
	}

	private func subscribePhotoStateSkippingRepeats() {
		store.subscribe(self) { subscription in
			subscription.select { state in

				let selectedCollection: UnsplashCollection? = state.navigationState.getRouteSpecificState(state.navigationState.route)
				let collectionPhotosSceneState = state.unsplashData.collectionPhotosScene

				let photoState = state.photoState

				return (selectedCollection, collectionPhotosSceneState, photoState)
			}
		}
	}

	private func unsubscribePhotoState() {
		store.unsubscribe(self)
	}
}
