//
//  NutritionApiService.swift
//  Nutrition
//
//  Created by ChrisTappin on 05/04/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import Foundation

enum NutritionAPIError: Error {
    case genericError
}

protocol NutritionAPIServiceProtocol {

    func getById(foodId: Int, completion: @escaping (Result<NutritionResponse, NutritionAPIError>) -> Void)

}

class NutritionAPIService: NutritionAPIServiceProtocol {

    var httpController: HTTPControllerProtocol?

    init(httpController: HTTPControllerProtocol = HTTPController()) {
        self.httpController = httpController
    }

    func getById(foodId: Int,
                 completion: @escaping (Result<NutritionResponse, NutritionAPIError>) -> Void) {
        let nutritionRequest = NutritionRequest(foodId: foodId)

        httpController?.process(nutritionRequest) { result in
            switch result {
            case .failure:
                completion(.failure(.genericError))
            case .success(let response):
                completion(.success(response))
            }
        }
    }

}
