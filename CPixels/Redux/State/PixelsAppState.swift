//
//  UnsplashAppState.swift
//  CPixels
//
//  Created by Joel Meng on 7/27/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation
import ReSwift
import UIKit

struct PixelsAppState: StateType, Equatable {

	var dataState: PixelsDataState = PixelsDataState()

	var loadingState: LoadingTaskState = LoadingTaskState()

	var photoState: PhotoLoadingState = PhotoLoadingState()

	var interactionState: UserInteractionState = UserInteractionState()
}

struct PixelsDataState: StateType, Equatable {

	var unsplashFeaturedCollections: [UnsplashCollection] = []
}

// MARK: - Rest Data State

enum DataReadyState {

	case initilized
	case loading
	case ready
	case outdated
	case error
}

struct LoadingTaskState: StateType, Equatable {

	var tasks: [PixelsData: DataReadyState] = [:]
}

// MARK: - Loaded photos state

struct PhotoLoadingState: StateType, Equatable {

	var loaded: [String: UIImage] = [:]
}

// MARK: - User interaction state

struct UserInteractionState: StateType, Equatable {

	var selectedFeatureCollection: UserSelectionAction?
}

