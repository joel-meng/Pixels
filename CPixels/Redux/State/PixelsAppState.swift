//
//  UnsplashAppState.swift
//  CPixels
//
//  Created by Joel Meng on 7/27/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation
import ReSwift

struct PixelsAppState: StateType, Equatable {

	var dataState: PixelsDataState = PixelsDataState()

	var loadingState: LoadingTaskState = LoadingTaskState()
}

struct PixelsDataState: StateType, Equatable {

	var unsplashFeaturedCollections: [UnsplashCollection] = []
}

struct LoadingTaskState: StateType, Equatable {

	var tasks: [PixelsData: DataReadyState] = [:]
}

enum DataReadyState {
	
	case initilized
	case loading
	case ready
	case outdated
	case error
}
