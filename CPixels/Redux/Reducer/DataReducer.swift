//
//  DataReducer.swift
//  CPixels
//
//  Created by Joel Meng on 7/27/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation
import ReSwift
import UIKit

func dataReducer(action: Action, state: PixelsDataState?) -> PixelsDataState {

	var state = state ?? PixelsDataState()

	guard let action = action as? RestFetch else { return state }

	state.collectionScene = collectionSceneReducer(action: action, state: state.collectionScene)

	return state
}

func collectionSceneReducer(action: Action, state: CollectionsSceneState?) -> CollectionsSceneState {

	var state = state ?? CollectionsSceneState()

	guard let action = action as? RestFetch,
		case let .fetchCollections(restState) = action else {
		return state
	}

	state.unsplashCollectionsState = restState

	return state
}

func photoLoadingStateReducer(action: Action, state: PhotoLoadingState?) -> PhotoLoadingState {

	var state = state ?? PhotoLoadingState()

	guard let imageFetchingAction = action as? ImageFetchAction else {
		return state
	}

	switch imageFetchingAction.loadingState {
	case .success(let image):
		state.loaded[imageFetchingAction.imageURL] = image as? UIImage
//		state.counter[imageFetchingAction.imageURL] = (state.counter[imageFetchingAction.imageURL] ?? 0) + 1

	case .error, .started, .notStarted:
		break
	}

	return state
}

func userInteractionStateReducer(action: Action, state: UserInteractionState?) -> UserInteractionState {

	var state = state ?? UserInteractionState()

	guard let action = action as? UserSelectionAction else { return state }

	switch action {
	case .selectedFeatureCollection:
		state.selectedFeatureCollection = action
	}

	return state
}
