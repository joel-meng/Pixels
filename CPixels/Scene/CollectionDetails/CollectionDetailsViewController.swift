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

	@IBOutlet var collectionView: CollectionView! {
		didSet {
			collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		}
	}

	@IBOutlet var messageLabel: UILabel!
	
	@IBOutlet var activityIndicator: UIActivityIndicatorView!

	// MARK: - States

	private var screenState: ViewState<CollectionDetailsViewController> = .uninitialized {
		didSet {
			screenState.update(view: self)
		}
	}

	// MARK: - CollectionView Provider

	private var collectionProvider: BasicProvider<UIImage, UIImageView>?

	// MARK: - Store subscriber

	private var storeSubscriber: CollectionDetailsStoreSubscriber?

	// MARK: - Lifecycles

	override func viewDidLoad() {
        super.viewDidLoad()

		configCollectionView(collectionView)

		storeSubscriber = CollectionDetailsStoreSubscriber(
			stateUpdater: { [weak self] (state, images) in
				self?.screenState = state
				if let images = images {
					self?.collectionProvider?.dataSource = ArrayDataSource(data: images)
				}
			},
			titleUpdater: { [weak self] title in
				self?.title = title ?? "Previews"
			}
		)

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

		let visibleFrameInsets = UIEdgeInsets(top: 0, left: -100, bottom: 0, right: -100)
		let provider = BasicProvider(dataSource: [UIImage](),
									 viewSource: viewSource,
									 sizeSource: UIImageSizeSource(),
									 layout: WaterfallLayout(columns: 2, spacing: 10).insetVisibleFrame(by: visibleFrameInsets),
									 animator: ScaleAnimator())

		collectionView.provider = provider
		collectionProvider = provider
	}
}

// MARK: - StatefulView

extension CollectionDetailsViewController: StatefulView {

	var mainView: UIView! {
		return collectionView
	}
}
