//
//  Rest.swift
//  CPixels
//
//  Created by Joel Meng on 7/24/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation
import UIKit

enum Rest {

	static func loadImage(request: RestRequest,
						  session: BlazingFastURLSession = URLSession.shared,
						  completion: @escaping (_ result: Result<UIImage, Error>) -> Void) -> URLSessionDataTaskProtocol? {
		return load(request: request) { (result) in
			guard let data = try? result.get() else {
				if case .failure(let error) = result {
					completion(Result.failure(error))
				}
				return
			}

			if let image = UIImage(data: data) {
				completion(Result.success(image))
			}

			completion(Result.failure(NSError(domain: "ERROR.DOMAIN",
											  code: 001,
											  userInfo: ["Error decoding Data": data])))
		}
	}

	// MARK: - Load Codable Data
    
    static func load<T: Codable>(request: RestRequest,
                                 session: BlazingFastURLSession = URLSession.shared,
                                 dateDecodingStrategy: JSONDecoder.DateDecodingStrategy?,
                                 expectedResultType: T.Type,
                                 completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let decoder = JSONDecoder()
        if let dateDecodingStrategy = dateDecodingStrategy {
            decoder.dateDecodingStrategy = dateDecodingStrategy
        }
        return load(request: request, session: session, decoder:decoder, expectedResultType:expectedResultType, completion:completion)
    }
    
    static func load<T: Codable>(request: RestRequest,
								 session: BlazingFastURLSession = URLSession.shared,
								 decoder: JSONDecoder = JSONDecoder(),
								 expectedResultType: T.Type,
								 completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTaskProtocol? {

		return load(request: request, session: session) { dataResult in
			switch dataResult {
			case .failure(let error):
				completion(Result.failure(error))
			case .success(let data):
				do {
					let decoded = try decoder.decode(T.self, from: data)
					completion(Result.success(decoded))
				} catch {
					completion(Result.failure(error))
				}
			}
		}
    }


	// MARK: - General Pure DataTask Loading


	static func load(request: RestRequest,
					 session: BlazingFastURLSession = URLSession.shared,
					 completion: @escaping (_ result: Result<Data, Error>) -> Void) -> URLSessionDataTaskProtocol? {

		guard let request = request.request() else {
			return nil
		}

		let task = session.dataTask(with: request) { data, response, err in
			if let response = response as? HTTPURLResponse {
				if response.wasSuccessful == false {
					let error = NSError(domain: "ERROR.DOMAIN", code: response.statusCode, userInfo: nil)
					completion(Result.failure(error))
					return
				}
			}

			if let data = data {
				completion(Result.success(data))
				return
			}

			if let err = err {
				completion(Result.failure(err))
			}
		}
		task.resume()
		return task
	}
}
