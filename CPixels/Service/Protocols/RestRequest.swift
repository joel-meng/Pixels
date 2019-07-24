//
//  RestRequest.swift
//  CPixels
//
//  Created by Joel Meng on 7/24/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation

protocol RestRequest {
    func request() -> URLRequest?
}

protocol RestRequestDecorator: RestRequest {
    var baseRequest: RestRequest { get }
}
