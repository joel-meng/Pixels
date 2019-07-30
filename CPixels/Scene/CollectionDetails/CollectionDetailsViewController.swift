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
import ReSwiftThunk

class CollectionDetailsViewController: UIViewController {

	@IBOutlet var collectionView: CollectionView!

	var featuredCollection: UnsplashCollection?
	private var collectionPhotoURLs: [String]?
	private var collectionProvider: BasicProvider<UIImage, UIImageView>?

	override func viewDidLoad() {
        super.viewDidLoad()
		title = "Previews"

		store.subscribe(self)
		{ subscription in
			subscription.select { $0.photoState }
		}

		configCollectionView(collectionView)
		dispatchFetchCollectionPhotoAction(featuredCollection)
    }

	override func viewDidDisappear(_ animated: Bool) {
		store.unsubscribe(self)
		super.viewDidDisappear(animated)
	}

	private func configCollectionView(_ collectionView: CollectionView) {

		let viewSource = ClosureViewSource { (imageView: UIImageView, data: UIImage, index: Int) in
			imageView.contentMode = .scaleAspectFit
			imageView.image = data
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

	func newState(state: PhotoLoadingState) {

//		if featuredCollection == nil {
//			if case .selectedFeatureCollection(let id)? = state.interactionState.selectedFeatureCollection {
//
//				let featuredCollection = state.dataState.unsplashFeaturedCollections.first(where: { (collection) -> Bool in
//					collection.id == id
//				})
//				self.featuredCollection = featuredCollection
//				dispatchFetchCollectionPhotoAction(featuredCollection)
//			}
//			return
//		}

		if let collectionPhotoURLs = collectionPhotoURLs {

			let loadedPhotos = collectionPhotoURLs.compactMap { (url) -> UIImage? in
				if let image = state.loaded[url] {
					return image
				}
				return nil
			}

			DispatchQueue.main.async { [weak self] in
				self?.collectionProvider?.dataSource = ArrayDataSource(data: loadedPhotos)
				self?.collectionView.setNeedsReload()
			}
		}
	}

	private func dispatchFetchCollectionPhotoAction(_ featuredCollection: UnsplashCollection?) {
		if let smallPreviewPhotos = featuredCollection?.previewPhotos?.compactMap({ $0.urls?.small }) {
			self.collectionPhotoURLs = smallPreviewPhotos
			smallPreviewPhotos.forEach { (url) in
				store.dispatch(fetchImage(withURL: url))
			}
		}
	}
}

private func fetchImage(withURL imageUrl: String) -> Thunk<PixelsAppState> {

	return Thunk<PixelsAppState> { (dispatch, getState) in

		guard let state = getState() else { return }

		if nil != state.photoState.loaded[imageUrl] {
			dispatch(ImageFetchAction(imageURL: imageUrl, loadingState: .cached))
			return
		}

		dispatch(ImageFetchAction(imageURL: imageUrl, loadingState: .started))

		UnsplashService.loadImage(withURL: imageUrl, completion: { (result) in
			guard let loadedImage = try? result.get() else { return }
			dispatch(ImageFetchAction(imageURL: imageUrl, loadingState: .success(loadedImage)))
		})?.resume()
	}
}
