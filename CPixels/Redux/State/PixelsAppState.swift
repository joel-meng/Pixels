//
//  UnsplashAppState.swift
//  CPixels
//
//  Created by Joel Meng on 7/27/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftRouter
import UIKit



struct PixelsAppState: StateType {

	var unsplashData: PixelsDataState = PixelsDataState()

	var photoState: PhotoLoadingState = PhotoLoadingState()

	var interactionState: UserInteractionState = UserInteractionState()

	var navigationState: NavigationState = NavigationState()
}

struct PixelsDataState: StateType, Equatable {

	var collectionScene: CollectionsSceneState = CollectionsSceneState()
}

struct CollectionsSceneState: StateType, Equatable {

	var unsplashCollectionsState: RestFetchingState = RestFetchingState<[UnsplashCollection]>.notStarted
}

// MARK: - Rest Data

enum RestFetchingState<Data>: Equatable where Data: Equatable {
	case notStarted
	case loading
	case ready(Data)
	case outdated
	case error(String)
}

// MARK: - Rest Data State

enum DataReadyState {

	case initilized
	case loading
	case ready
	case outdated
	case error
}


// MARK: - Loaded photos state

struct PhotoLoadingState: StateType, Equatable {

	var loaded: [String: UIImage] = [:]
	
//	var counter: [String: Int] = [:]
}

// MARK: - User interaction state

struct UserInteractionState: StateType, Equatable {

	var selectedFeatureCollection: UserSelectionAction?
}

