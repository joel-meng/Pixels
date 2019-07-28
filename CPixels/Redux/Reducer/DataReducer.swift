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

	guard let action = action as? DataRequestAction else { return state}

	guard case let .success(data) = action.loadingState else { return state }

	switch action.dataSet {
	case .featuredCollection:
		state.unsplashFeaturedCollections = data as! [UnsplashCollection]
	}

	return state
}

func dataLoadingStateReducer(action: Action, state: LoadingTaskState?) -> LoadingTaskState {

	var state = state ?? LoadingTaskState()

	guard let action = action as? DataRequestAction else { return state}

	switch action.loadingState {
	case .error:
		state.tasks[action.dataSet] = .error
	case .started:
		state.tasks[action.dataSet] = .loading
	case .success:
		state.tasks[action.dataSet] = .ready
	case .notStarted:
		break
	}

	return state
}

func photoLoadingStateReducer(action: Action, state: PhotoLoadingState?) -> PhotoLoadingState {

	let state = state ?? PhotoLoadingState()

	return state
}
