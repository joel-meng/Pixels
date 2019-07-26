//
//  DataActions.swift
//  CPixels
//
//  Created by Joel Meng on 7/27/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation
import ReSwift

protocol DataAction: Action {}

enum FetchDataAction: DataAction {
	case featuredCollection([UnsplashCollection])
}
