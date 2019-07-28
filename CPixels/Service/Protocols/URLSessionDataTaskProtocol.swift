//
//  URLSessionDataTaskProtocol.swift
//  CPixels
//
//  Created by Joel Meng on 7/24/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation

public protocol URLSessionDataTaskProtocol {
    func resume()
	func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
