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
    case transmissionFailure
    case badRequest
    case notFound
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

            session.urlDataTask(with: request.url) { data, response, error in
                guard error == nil else {
                    completion(.failure(.transmissionFailure))
                    return
                }

                if let response = response as? HTTPURLResponse {
                    guard 200...299 ~= response.statusCode else {
                        switch response.statusCode {
                        case 400:
                            completion(.failure(.badRequest))
                        case 404:
                            completion(.failure(.notFound))
                        default:
                            completion(.failure(.genericError))
                        }

                        return
                    }
                }
                
                if let data = data {
                    guard let responseObject = request.response(data: data) else {
                        return
                    }
                    completion(.success(responseObject))
                }
            }

    }

}
