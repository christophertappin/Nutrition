//
//  Requests.swift
//  Nutrition
//
//  Created by ChrisTappin on 05/04/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import Foundation

enum LifesumAPI {
    static let scheme = "https"
    static let host = "api.lifesum.com"
    static let path = "v2/foodipedia/codetest"
}

protocol Request {
    associatedtype ResponseType: Decodable

    var url: URL { get }
    var path: String { get }
    var request: URLRequest { get }
    var queryItems: [URLQueryItem] { get }

    func response(data: Data) -> ResponseType?
}

extension Request {
    var url: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = LifesumAPI.scheme
        urlComponents.host = LifesumAPI.host
        urlComponents.path = path
        urlComponents.queryItems = queryItems

        return urlComponents.url!
    }

    var request: URLRequest {
        var request = URLRequest(url: url)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        return request
    }

    var token: String {
        return "23863708:465c0554fd00da006338c72e282e939fe6576a25fd00c776c0fbe898c47c9876"
    }
}

struct NutritionRequest: Request {
    typealias ResponseType = NutritionResponse

    var path = "/v2/foodipedia/codetest"
    var queryItems: [URLQueryItem] = []

    init(foodId: Int) {
        queryItems.append(URLQueryItem(name: "foodid", value: String(foodId)))
    }

    func response(data: Data) -> NutritionResponse? {
        let response = try? JSONDecoder().decode(NutritionResponseWrapper.self, from: data)

        return response?.response
    }
}

struct NutritionResponse: Decodable {
    let title: String
    let pcstext: String

    let gramsperserving: Float

    let calories: Int

    let carbs: Float
    let protein: Float
    let fat: Float

    let unsaturatedfat: Float
    let saturatedfat: Float

    let fiber: Float
    let potassium: Float
    let sodium: Float
    let sugar: Float
    let cholesterol: Float
}

struct NutritionResponseWrapper: Decodable {
    let response: NutritionResponse
}
