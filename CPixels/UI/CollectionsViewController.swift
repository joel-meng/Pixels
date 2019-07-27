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

	override func viewDidLoad() {
		super.viewDidLoad()
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
