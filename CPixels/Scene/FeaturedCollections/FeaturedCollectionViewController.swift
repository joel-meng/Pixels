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

	@IBOutlet var loadingIndicator: UIActivityIndicatorView!

	@IBOutlet var tableView: UITableView! {
		didSet {
			self.tableView.dataSource = self
			self.tableView.delegate = self
			tableView.contentInsetAdjustmentBehavior = .never

			let nib = UINib(nibName: "FeaturedCollectionTableViewCell", bundle: nil)
			tableView.register(nib, forCellReuseIdentifier: "FeaturedCollectionTableViewCell")
		}
	}

	var featuredCollections: [UnsplashCollection] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Featured"

		store.subscribe(self) { subscription in
			subscription.select({ (state) in
				return state.unsplashData.collectionScene
			}).skipRepeats()

		}
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

	// MARK: - UI

	private func showLoading() {
		DispatchQueue.main.async { [weak tableView, loadingIndicator] in
			tableView?.isHidden = true
			loadingIndicator?.startAnimating()
			loadingIndicator?.isHidden = false
		}
	}

	private func showCollection(_ collection: [UnsplashCollection]) {
		featuredCollections = collection

		DispatchQueue.main.async { [weak tableView, loadingIndicator] in
			tableView?.isHidden = false
			tableView?.reloadData()
			loadingIndicator?.stopAnimating()
			loadingIndicator?.isHidden = true
		}
	}

	private func showError(_ message: String) {

	}
}



extension FeaturedCollectionViewController: StoreSubscriber {

	func newState(state: CollectionsSceneState) {

		switch state.unsplashCollectionsState {
		case .loading:
			showLoading()
		case .ready(let data):
			showCollection(data)
		case .error(let errorMessage):
			showError(errorMessage)
		case .outdated:
			showCollection([])
		default:
			break
		}
	}
}

extension FeaturedCollectionViewController: UITableViewDataSource, UITableViewDelegate {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return featuredCollections.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedCollectionTableViewCell",
												 for: indexPath) as! FeatureCollectionTableViewCell
		cell.configure(with: featuredCollections[indexPath.row])
		return cell
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 160
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedCollection = featuredCollections[indexPath.row]

//		store.dispatch(UserSelectionAction.selectedFeatureCollection(selectedCollectionId!))

		let collectionDetailsViewController = CollectionDetailsViewController(nibName: "CollectionDetailsViewController",
																			  bundle: nil)
		collectionDetailsViewController.featuredCollection = selectedCollection
		show(collectionDetailsViewController, sender: self)
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
