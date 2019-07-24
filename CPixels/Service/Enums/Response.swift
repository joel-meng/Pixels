//
//  Response.swift
//  CPixels
//
//  Created by Joel Meng on 7/24/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation

enum Response<T> {
    case success(T)
    case failure(Error)
}
