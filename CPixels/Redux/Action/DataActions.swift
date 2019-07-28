//
//  DataActions.swift
//  CPixels
//
//  Created by Joel Meng on 7/27/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation
import ReSwift

protocol DataAction: Action {

	var dataSet: PixelsData { get }

	var loadingState: AsyncLoadingState { get }
}

enum AsyncLoadingState {

	case notStarted
	case started
	case success(Any)
	case error(Error)
}

enum PixelsData {

	case featuredCollection
}

struct DataRequestAction: DataAction {

	let dataSet: PixelsData
	
	let loadingState: AsyncLoadingState
}

// MARK: - Image Download Action

protocol DownloadAction: Action {}

struct ImageFetchAction: DownloadAction {

	let imageURL: String

	let loadingState: AsyncLoadingState
}
