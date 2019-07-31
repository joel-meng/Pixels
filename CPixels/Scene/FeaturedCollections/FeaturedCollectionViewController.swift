//
//  FeaturedCollectionViewController.swift
//  CPixels
//
//  Created by Joel Meng on 7/28/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import UIKit
import ReSwift
import ReSwiftThunk

class FeaturedCollectionViewController: UIViewController {

	@IBOutlet var statedTableView: StatedTableView!

	private var tableUpdater: ((StatedTableView.State<[UnsplashCollection]>) -> Void)?

//	@IBOutlet var tableView: UITableView! {
//		didSet {
//			self.tableView.dataSource = self
//			self.tableView.delegate = self
//			tableView.contentInsetAdjustmentBehavior = .never
//
//			let nib = UINib(nibName: "FeaturedCollectionTableViewCell", bundle: nil)
//			tableView.register(nib, forCellReuseIdentifier: "FeaturedCollectionTableViewCell")
//		}
//	}

	var featuredCollections: [UnsplashCollection] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Collections"

		store.subscribe(self) { subscription in
			subscription.select({ (state) in
				return state.unsplashData.collectionScene
			}).skipRepeats()
		}

		tableUpdater = statedTableView.updater { (item, cell) in}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if featuredCollections.isEmpty {
			store.dispatch(fetchCollectionThunk)
		}
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		store.unsubscribe(self)
	}

}

extension FeaturedCollectionViewController: StoreSubscriber {

	func newState(state: CollectionsSceneState) {

		switch state.unsplashCollectionsState {

		case .loading:
			let state = StatedTableView.State<[UnsplashCollection]>.loading
			tableUpdater?(state)
		case .ready(let data):
			let state = StatedTableView.State<[UnsplashCollection]>.data(data)
			tableUpdater?(state)
		case .error(let error):
			let state = StatedTableView.State<[UnsplashCollection]>.error(error)
			tableUpdater?(state)
		case .outdated:
			let state = StatedTableView.State<[UnsplashCollection]>.empty
			tableUpdater?(state)
		case .notStarted:
			let state = StatedTableView.State<[UnsplashCollection]>.initial
			tableUpdater?(state)
		}
	}
}

fileprivate let fetchCollectionThunk = Thunk<PixelsAppState> { (dispatch, getState) in

	guard let state = getState() else { return }


	dispatch(RestFetch.fetchCollections(.loading))

	UnsplashService.listCollections { (response) in
		DispatchQueue.main.async {
			switch response {
			case .success(let result):
				dispatch(RestFetch.fetchCollections(.ready(result)))
			case .failure(let error):
				dispatch(RestFetch.fetchCollections(.error("\(error)")))
			}
		}
	}?.resume()
}
