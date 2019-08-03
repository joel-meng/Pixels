//
//  Reducers.swift
//  CPixels
//
//  Created by Joel Meng on 7/27/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftRouter

func reducer(action: Action, state: PixelsAppState?) -> PixelsAppState {
	
	return PixelsAppState(
		unsplashData: dataReducer(action: action, state: state?.unsplashData),
		photoState: photoLoadingStateReducer(action: action, state: state?.photoState),
		navigationState: NavigationReducer.handleAction(action, state: state?.navigationState)
	)
}
