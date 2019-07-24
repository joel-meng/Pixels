//
//  UnsplashRequest.swift
//  CPixels
//
//  Created by Joel Meng on 7/24/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation

struct UnsplashRequest: RestRequest {
    
    private static let unsplashBaseURL = "https://api.unsplash.com/v1"
    
    private let path: String
    
    init(path: String) {
        self.path = path
    }
    
    func request() -> URLRequest? {
        guard let url = URL(string: UnsplashRequest.unsplashBaseURL) else { return nil }
        guard let pathURL = URL(string: path, relativeTo: url) else { return nil }
        return URLRequest(url: pathURL)
    }
}
