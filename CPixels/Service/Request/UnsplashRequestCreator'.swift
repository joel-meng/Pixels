//
//  UnsplashRequestCreator'.swift
//  CPixels
//
//  Created by Joel Meng on 7/27/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation

func unsplashGETRequest(path: String) -> RestRequest {
	let reader = Reader<String, RestRequest> { UnsplashRequest(path: $0) }
	return ((reader >>= authorized) >>= get).apply(from: path)
}

private func authorized(_ base: RestRequest) -> RestRequest {
	return RestRequestAuthorizationDecorator(baseRequest: base)
}

private func request(withPath path: String) -> RestRequest {
	return UnsplashRequest(path: path)
}

private func get(_ base: RestRequest) -> RestRequest {
	return RestRequestMethodDecorator(method: .GET, baseRequest: base)
}
