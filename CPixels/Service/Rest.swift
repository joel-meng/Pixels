//
//  Rest.swift
//  CPixels
//
//  Created by Joel Meng on 7/24/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation

enum Rest {
    
    static func load<T: Codable>(request: RestRequest,
                                 session: BlazingFastURLSession = URLSession.shared,
                                 dateDecodingStrategy: JSONDecoder.DateDecodingStrategy?,
                                 expectedResultType: T.Type,
                                 completion: @escaping (_ json: T?, _ error: Error?) -> Void) -> URLSessionDataTaskProtocol? {
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
								 completion: @escaping (_ json: T?, _ error: Error?) -> Void) -> URLSessionDataTaskProtocol? {
        
        guard let request = request.request() else {
            return nil
        }
        
        let task = session.dataTask(with: request) { data, response, err in
            if let response = response as? HTTPURLResponse {
                if response.wasSuccessful == false {
                    var userInfo = [String: Any]()
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        userInfo["RestRequestErrorKey"] = json as Any?
                    }
                    let error = NSError(domain: "ERROR.DOMAIN", code: response.statusCode, userInfo: userInfo)
                    completion(nil, error)
                    return
                }
            }
            
            if let err = err {
                completion(nil, err)
            } else {
                if let data = data {
                    do {
                        let decoded = try decoder.decode(T.self, from: data)
                        completion(decoded, nil)
                    } catch {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
}
