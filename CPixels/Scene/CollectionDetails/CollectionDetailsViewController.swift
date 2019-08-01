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

final class CollectionDetailsViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet var collectionView: CollectionView!

	// MARK: - Selections

	var featuredCollection: UnsplashCollection? {
		didSet {
			collectionPhotoURLs = featuredCollection?.previewPhotos?.compactMap({ $0.urls?.small })
		}
	}

	private var collectionPhotoURLs: [String]?

	// MARK: - States

	private var collectionProvider: BasicProvider<UIImage, UIImageView>?

	// MARK: - Lifecycles

	override func viewDidLoad() {
        super.viewDidLoad()
		title = featuredCollection?.title ?? "Previews"

		subscribePhotoStateSkippingRepeats()

		configCollectionView(collectionView)

		dispatchFetchCollectionPhotoAction(featuredCollection)
    }

	deinit {
		unsubscribePhotoState()
	}

	// MARK: - UIgst configuration

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

	func newState(state: PhotoLoadingState) {

		guard let loadedPhotos = collectionPhotoURLs?.compactMap({ (url) -> UIImage? in
			if let image = state.loaded[url] {
				return image
			}
			return nil
		}) else { return }

		DispatchQueue.main.async { [weak self] in
			self?.collectionProvider?.dataSource = ArrayDataSource(data: loadedPhotos)
		}
	}

	private func subscribePhotoStateSkippingRepeats() {
		store.subscribe(self) { subscription in
			subscription.select { $0.photoState }.skipRepeats()
		}
	}

	private func unsubscribePhotoState() {
		store.unsubscribe(self)
	}

	private func dispatchFetchCollectionPhotoAction(_ featuredCollection: UnsplashCollection?) {
		collectionPhotoURLs?.forEach { (url) in
			store.dispatch(fetchImage(withURL: url))
		}
	}
}
