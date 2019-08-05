//
//  FetchCollectionsThunk.swift
//  CPixels
//
//  Created by Joel Meng on 7/31/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation
import ReSwiftThunk

func fetchCollection(collectionPerPage: Int = 10, page: Int = 1) -> Thunk<PixelsAppState> {

	return Thunk<PixelsAppState> { (dispatch, getState) in

		guard let state = getState() else { return }

		let collectionLoadingState = state.unsplashData.collectionScene.unsplashCollections

		if case .loading? = collectionLoadingState[page] {
			// skip loading/loaded pages
			return
		}

		if case .ready? = collectionLoadingState[page] {
			// skip loading/loaded pages
			return
		}

		print("dispatching loading request for page \(page)")
		dispatch(RestFetch.fetchCollections(.loading, page))

		UnsplashService.listCollections(page: page) { (response) in
			DispatchQueue.main.async {
				switch response {
				case .success(let result):
					dispatch(RestFetch.fetchCollections(.ready(result), page))
				case .failure(let error):
					dispatch(RestFetch.fetchCollections(.error("\(error)"), page))
				}
			}
		}?.resume()
	}
}

func fetchCollectionPhotos(collectionID: Int, photosPerPage: Int) -> Thunk<PixelsAppState> {

	let fetchCollectionPhotos = Thunk<PixelsAppState> { (dispatch, getState) in

		dispatch(RestFetch.fetchCollectionPhotos(.loading))

		UnsplashService.listCollectionPhotos(collectionID: collectionID,
											 photosPerPage: photosPerPage,
											 pageNumber: 1,
											 completion: { (result) in
			DispatchQueue.main.async {
				switch result {
				case .success(let result):
					dispatch(RestFetch.fetchCollectionPhotos(.ready(result)))
				case .failure(let error):
					dispatch(RestFetch.fetchCollectionPhotos(.error("\(error)")))
				}
			}
		})?.resume()
	}
	return fetchCollectionPhotos
}
