//
//  PixelsStore.swift
//  CPixels
//
//  Created by Joel Meng on 7/27/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftThunk


let thunkMiddleware: Middleware<PixelsAppState> = createThunksMiddleware()

let loggingMiddleware: Middleware<Any> = { dispatch, getState in
	return { next in
		return { action in
			// perform middleware logic
			print(action)

			// call next middleware
			return next(action)
		}
	}
}

let store = Store(
	reducer: reducer,
	state: PixelsAppState(),
	middleware: [thunkMiddleware],//, loggingMiddleware],
	automaticallySkipsRepeats: false
)
