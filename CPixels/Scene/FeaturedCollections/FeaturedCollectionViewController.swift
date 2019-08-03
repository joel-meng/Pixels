//
//  FeaturedCollectionViewController.swift
//  CPixels
//
//  Created by Joel Meng on 7/28/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import UIKit
import ReSwift
import ReSwiftRouter

class FeaturedCollectionViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet var statedTableView: StatedTableView!

	// MARK: - States

	private var tableUpdater: ((StatedTableView.State<[UnsplashCollection]>) -> Void)?

	private var tableState: StatedTableView.State<[UnsplashCollection]>?

	// MARK: - Lifecycle methods

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Collections"

		subscribeStoreUpdate()

		configureStatedTableView()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		fetchCollectionsIfNeeded()
	}

	deinit {
		unsubscribeStoreUpdate()
	}

	// MARK: - UI Configuration

	private func configureStatedTableView() {
		tableUpdater = statedTableView.tapAction { item in
			let route = [mainViewRoute, photosViewRoute]
			let dataAction = SetRouteSpecificData(route: route, data: item)
			let routeAction = SetRouteAction(route, animated: true)

			store.dispatch(dataAction)
			store.dispatch(routeAction)
		}
	}
}

// MARK: - StoreSubscriber

extension FeaturedCollectionViewController: StoreSubscriber {

	private func fetchCollectionsIfNeeded() {
		switch tableState! {
		case .initial:
			store.dispatch(fetchCollection)
		default:
			break
		}
	}

	private func unsubscribeStoreUpdate() {
		store.unsubscribe(self)
	}

	private func subscribeStoreUpdate() {
		store.subscribe(self) { subscription in
			subscription.select({ (state) in
				return state.unsplashData.collectionScene
			}).skipRepeats()
		}
	}

	func newState(state: CollectionsSceneState) {
		let state = StatedTableView.State<[UnsplashCollection]>.fromRestFetchState(state.unsplashCollections)
		self.tableState = state
		tableUpdater?(state)
	}
}
