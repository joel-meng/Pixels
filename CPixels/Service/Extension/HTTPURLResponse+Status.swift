//
//  AppDelegate.swift
//  CPixels
//
//  Created by Joel Meng on 7/24/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    public var wasSuccessful: Bool {
        let successRange = 200..<300
        return successRange.contains(statusCode)
    }
}
