//
//  FetchImageThunk.swift
//  CPixels
//
//  Created by Joel Meng on 7/31/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation
import ReSwiftThunk

func fetchImage(withURL imageUrl: String) -> Thunk<PixelsAppState> {

	return Thunk<PixelsAppState> { (dispatch, getState) in

		guard let state = getState() else { return }

		if nil != state.photoState.loaded[imageUrl] {
			// skip loaded image
			return
		}

		if state.photoState.loading.contains(imageUrl) {
			// skip loading image
			return
		}

		dispatch(ImageFetchAction(imageURL: imageUrl, loadingState: .started))

		UnsplashService.loadImage(withURL: imageUrl, completion: { (result) in
			guard let loadedImage = try? result.get() else { return }
			dispatch(ImageFetchAction(imageURL: imageUrl, loadingState: .success(loadedImage)))
		})?.resume()
	}
}
