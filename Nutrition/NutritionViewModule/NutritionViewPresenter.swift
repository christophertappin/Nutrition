//
//  NutritionViewPresenter.swift
//  Nutrition
//
//  Created by ChrisTappin on 05/04/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import Foundation

protocol NutritionViewPresenterProtocol {
    var view: NutritionViewControllerProtocol? { get set }
    var interactor: NutritionViewInteractorProtocol? { get set }

    func title() -> String
    func carbValue() -> String
    func fatValue() -> String
    func proteinValue() -> String
    func calorieValue() -> String
    func load()

}

protocol NutritionViewEventProtocol {
    func resultSuccess(response: NutritionResponse)
    func resultFailure()
}

class NutritionViewPresenter: NutritionViewPresenterProtocol {
    var view: NutritionViewControllerProtocol?

    var interactor: NutritionViewInteractorProtocol?

    var response: NutritionResponse?

    func title() -> String {
        return response?.title ?? ""
    }

    func carbValue() -> String {
        return String(response?.carbs ?? 0.0)
    }

    func fatValue() -> String {
        return String(response?.fat ?? 0.0)
    }

    func proteinValue() -> String {
        return String(response?.protein ?? 0.0)
    }

    func calorieValue() -> String {
        return String(response?.calories ?? 0)
    }

    func load() {
        interactor?.loadRandomResult()
    }

}

extension NutritionViewPresenter: NutritionViewEventProtocol {
    func resultSuccess(response: NutritionResponse) {
        self.response = response
        DispatchQueue.main.async {
            self.view?.fetchItemSuccess()
        }
    }

    func resultFailure() {
        DispatchQueue.main.async {
            self.view?.fetchItemFailure()
        }
    }

}
