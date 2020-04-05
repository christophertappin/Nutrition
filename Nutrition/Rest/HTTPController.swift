//
//  HTTPController.swift
//  Nutrition
//
//  Created by ChrisTappin on 05/04/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import Foundation

enum HTTPError: Error {
    case genericError
}

protocol HTTPURLSession {
    func urlDataTask(with url: URL,
                     completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: HTTPURLSession {
    func urlDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTask(with: url) { (data, response, error) in
            completionHandler(data, response, error)
        }.resume()
    }

}

protocol HTTPControllerProtocol {
    func process<T>(_ request: T,
                    completionHandler completion: @escaping (Result<T.ResponseType, HTTPError>) -> Void)
        where T: Request
}

class HTTPController: HTTPControllerProtocol {

    private let session: HTTPURLSession

    init(session: HTTPURLSession = URLSession.shared) {
        self.session = session
    }

    func process<T>(_ request: T,
                    completionHandler completion: @escaping (Result<T.ResponseType, HTTPError>) -> Void)
        where T: Request {

            session.urlDataTask(with: request.url) { data, response, _ in
                if let data = data {
                    guard let responseObject = request.response(data: data) else {
                        return
                    }
                    completion(.success(responseObject))
                }
            }

    }

}
