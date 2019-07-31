//
//  FetchCollectionsThunk.swift
//  CPixels
//
//  Created by Joel Meng on 7/31/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation
import ReSwiftThunk

let fetchCollectionThunk = Thunk<PixelsAppState> { (dispatch, getState) in

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
