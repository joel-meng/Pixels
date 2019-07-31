//
//  UnsplashService.swift
//  CPixels
//
//  Created by Joel Meng on 7/24/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation
import UIKit

struct UnsplashService {

	static func loadImage(withURL url: String, completion: @escaping (_ response: Result<UIImage, Error>) -> Void) -> URLSessionDataTaskProtocol? {
		let loadImageRequest = unsplashGETRequest(path: url)
		return Rest.loadImage(request: loadImageRequest) { (result) in
			completion(result)
		}
	}

	static func listCollections(completion: @escaping (_ response: Result<[UnsplashCollection], Error>) -> Void) -> URLSessionDataTaskProtocol? {
		let listCollectionsRequest = unsplashGETRequest(path: "/collections")
		let dateDecodingFormatter = JSONDecoder.DateDecodingStrategy.formatted(DateFormatter.rfc3339DateFormatter)

		return Rest.load(request: listCollectionsRequest,
						 dateDecodingStrategy: dateDecodingFormatter,
						 expectedResultType: [UnsplashCollection].self,
						 completion: completion)
	}
}
