//
//  Requests.swift
//  Nutrition
//
//  Created by ChrisTappin on 05/04/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import Foundation

protocol Request {
    associatedtype ResponseType: Decodable

    var url: URL { get }

    func response(data: Data) -> ResponseType?
}

struct NutritionRequest: Request {
    typealias ResponseType = NutritionResponse

    var url: URL = URL(string: "http://sample.url")!

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
