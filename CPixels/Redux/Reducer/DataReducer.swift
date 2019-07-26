//
//  DataReducer.swift
//  CPixels
//
//  Created by Joel Meng on 7/27/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation
import ReSwift

func dataReducer(action: Action, state: PixelsDataState?) -> PixelsDataState {

	var state = state ?? PixelsDataState()

	guard let action = action as? FetchDataAction else { return state}

	switch action {
	case .featuredCollection(let collections):
		state.unsplashFeaturedCollections = collections
	}

	return state
}
