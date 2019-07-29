//
//  Reducers.swift
//  CPixels
//
//  Created by Joel Meng on 7/27/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation
import ReSwift

func reducer(action: Action, state: PixelsAppState?) -> PixelsAppState {
	
	return PixelsAppState(
		dataState: dataReducer(action: action, state: state?.dataState),
		loadingState: dataLoadingStateReducer(action: action, state: state?.loadingState),
		photoState: photoLoadingStateReducer(action: action, state: state?.photoState),
		interactionState: userInteractionStateReducer(action: action, state: state?.interactionState)
	)
}
