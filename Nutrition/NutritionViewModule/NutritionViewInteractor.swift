//
//  NutritionViewInteractor.swift
//  Nutrition
//
//  Created by ChrisTappin on 05/04/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import Foundation

protocol NutritionViewInteractorProtocol {
    var presenter: NutritionViewEventProtocol? { get set }

    func loadRandomResult()
}

class NutritionViewInteractor: NutritionViewInteractorProtocol {

    weak var presenter: NutritionViewEventProtocol?

    var nutritionApiService: NutritionAPIServiceProtocol?

    // Prevent another request being sent if we're already getting one
    var requestInProgress: Bool = false

    init(nutritionApiService: NutritionAPIServiceProtocol = NutritionAPIService()) {
        self.nutritionApiService = nutritionApiService
    }

    func loadRandomResult() {
        if requestInProgress {
            return
        }
        requestInProgress = true
        let foodId = Int.random(in: 1...200)
        nutritionApiService?.getById(foodId: foodId) { [weak self] result in
            switch result {
            case .failure:
                self?.presenter?.resultFailure()
            case .success(let response):
                self?.presenter?.resultSuccess(response: response)
            }
            self?.requestInProgress = false
        }
    }
}
