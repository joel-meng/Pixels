//
//  UnsplashService.swift
//  CPixels
//
//  Created by Joel Meng on 7/24/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation

struct UnsplashService {

	func listCollections(completion: @escaping (_ response: Response<[UnsplashCollection]>) -> Void) -> URLSessionDataTaskProtocol? {
		let listCollectionsRequest =  authorized(get(request(withPath: "/collections/featured")))
		let dateDecodingFormatter = JSONDecoder.DateDecodingStrategy.formatted(DateFormatter.rfc3339DateFormatter)

		return Rest.load(request: listCollectionsRequest,
						 dateDecodingStrategy: dateDecodingFormatter,
						 expectedResultType: [UnsplashCollection].self) { repos, error in

							if let error = error {
								completion(Response.failure(error))
							}

							if let repos = repos {
								completion(Response.success(repos))
							}
		}
	}
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


