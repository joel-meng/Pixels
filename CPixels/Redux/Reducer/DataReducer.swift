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
	state.collectionPhotosScene = collectionPhotosSceneReducer(action: action, state: state.collectionPhotosScene)

	return state
}

func collectionSceneReducer(action: Action, state: CollectionsSceneState?) -> CollectionsSceneState {

	var state = state ?? CollectionsSceneState()

	guard let action = action as? RestFetch,
		case let .fetchCollections(restState) = action else {
		return state
	}

	state.unsplashCollections = restState

	return state
}

func collectionPhotosSceneReducer(action: Action, state: CollectionPhotosSceneState?) -> CollectionPhotosSceneState {

	var state = state ?? CollectionPhotosSceneState()

	guard let action = action as? RestFetch,
		case let .fetchCollectionPhotos(restState) = action else {
			return state
	}

	state.collectionPhotos = restState

	return state
}


func photoLoadingStateReducer(action: Action, state: PhotoLoadingState?) -> PhotoLoadingState {

	var state = state ?? PhotoLoadingState()

	guard let imageFetchingAction = action as? ImageFetchAction else {
		return state
	}

	switch imageFetchingAction.loadingState {
	case .success(let image):
		state.loading.removeAll { (url) -> Bool in
			imageFetchingAction.imageURL == url
		}
		state.loaded[imageFetchingAction.imageURL] = image as? UIImage
//		state.counter[imageFetchingAction.imageURL] = (state.counter[imageFetchingAction.imageURL] ?? 0) + 1

	case .started:
		state.loading.append(imageFetchingAction.imageURL)
	case .error, .notStarted:
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
