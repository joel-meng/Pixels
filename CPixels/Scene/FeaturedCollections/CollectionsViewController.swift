//
//  ViewController.swift
//  CPixels
//
//  Created by Joel Meng on 7/24/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import UIKit
import ReSwift
import ReSwiftThunk

class CollectionsViewController: UIViewController {

	@IBOutlet var tableView: UITableView! {
		didSet {
			self.tableView.dataSource = self
		}
	}

	var featuredCollections: [UnsplashCollection] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Featured"
		
		store.subscribe(self) { subscription in
			subscription.skip(when: ==)
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		store.dispatch(fetchFeaturedCollectionThunk)
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		store.unsubscribe(self)
	}
}

extension CollectionsViewController: StoreSubscriber {

	func newState(state: PixelsAppState) {
		if case .loading? = state.loadingState.tasks[.featuredCollection] {
			return
		}
		if case .ready? = state.loadingState.tasks[.featuredCollection] {
			self.featuredCollections =  state.dataState.unsplashFeaturedCollections
			tableView.reloadData()
		}
	}
}

extension CollectionsViewController: UITableViewDataSource, UITableViewDelegate {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return featuredCollections.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedCollection",
												 for: indexPath) as! FeatureCollectionTableViewCell
		cell.configure(with: featuredCollections[indexPath.row])
		return cell
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 120
	}
}

fileprivate let fetchFeaturedCollectionThunk = Thunk<PixelsAppState> { (dispatch, getState) in

	guard let state = getState() else { return }

	dispatch(DataRequestAction(dataSet: .featuredCollection, loadingState: .started))

	UnsplashService.listCollections { (response) in
		switch response {
		case .success(let result):
			DispatchQueue.main.async {
				dispatch(DataRequestAction(dataSet: .featuredCollection,
										   loadingState: .success(result)))
			}
		case .failure(let error):
			DispatchQueue.main.async {
				dispatch(DataRequestAction(dataSet: .featuredCollection,
										   loadingState: .error(error)))
			}
		}
	}?.resume()
}
