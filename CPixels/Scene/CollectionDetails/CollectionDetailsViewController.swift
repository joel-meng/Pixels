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

	@IBOutlet var messageLabel: UILabel!
	
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	
	// MARK: - Selections

	var featuredCollection: UnsplashCollection? {
		didSet {
			title = featuredCollection?.title ?? "Previews"
		}
	}

	private var photoURLs: [String]?

	// MARK: - States

	private var screenState: ViewState<CollectionDetailsViewController> = .uninitialized {
		didSet {
			screenState.update(view: self)
		}
	}

	private var collectionProvider: BasicProvider<UIImage, UIImageView>?

	// MARK: - Store subscriber

	private var storeSubscriber: CollectionDetailsStoreSubscriber?

	// MARK: - Lifecycles

	override func viewDidLoad() {
        super.viewDidLoad()

		title = featuredCollection?.title ?? "Previews"

		configCollectionView(collectionView)

		storeSubscriber = CollectionDetailsStoreSubscriber(stateUpdater: { [weak self] (state, images) in
			self?.screenState = state
			if let images = images {
				DispatchQueue.main.async {
					self?.collectionProvider?.dataSource = ArrayDataSource(data: images)
				}
			}
		})

		storeSubscriber?.subscribePhotoStateSkippingRepeats()
    }

	override func didMove(toParent parent: UIViewController?) {
		if nil == parent {
			store.dispatch(SetRouteAction([mainViewRoute]))
		}
	}

	deinit {
		storeSubscriber?.unsubscribePhotoState()
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

// MARK: - StatefulView

extension CollectionDetailsViewController: StatefulView {

	var mainView: UIView! {
		return collectionView
	}
}
