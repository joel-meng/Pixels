//
//  DataActions.swift
//  CPixels
//
//  Created by Joel Meng on 7/27/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation
import ReSwift

protocol RestAction: Action {
}

enum AsyncLoadingState {

	case notStarted
	case started
	case success(Any)
	case error(Error)
}

enum RestFetch: Action {

	case fetchCollections(RestFetchingState<[UnsplashCollection]>)
	case fetchCollectionPhotos(RestFetchingState<[CoverPhoto]>)
}

// MARK: - Image Download Action

protocol DownloadAction: Action {}

struct ImageFetchAction: DownloadAction {

	let imageURL: String

	let loadingState: AsyncLoadingState
}

// MARK: - User Interaction Action

protocol UserInteractionAction: Action {}

enum UserSelectionAction: UserInteractionAction, Equatable {

	case selectedFeatureCollection(Int)
}



