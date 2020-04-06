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

    var title: String { get }
    var carbValue: String { get }
    var fatValue: String { get }
    var proteinValue: String { get }
    var calorieValue: String { get }

    func load()
    func macroValues() -> [String: Float]

}

protocol NutritionViewEventProtocol {
    func resultSuccess(response: NutritionResponse)
    func resultFailure()
}

class NutritionViewPresenter: NutritionViewPresenterProtocol {
    var view: NutritionViewControllerProtocol?

    var interactor: NutritionViewInteractorProtocol?

    var response: NutritionResponse?

    var title: String {
        return response?.title ?? ""
    }

    private var totalMacros: Float {
        let carbs: Float = response?.carbs ?? 0.0
        let fat: Float = response?.fat ?? 0.0
        let protein: Float = response?.protein ?? 0.0

        return carbs + fat + protein
    }

    var carbValue: String {
        guard totalMacros != 0 else {
                return ""
        }
        let carbPercentage = (response?.carbs ?? 0.0) / totalMacros * 100
        return String(format: "%.1f%%", carbPercentage)
    }

    var fatValue: String {
        guard totalMacros != 0 else {
                return ""
        }
        let carbPercentage = (response?.fat ?? 0.0) / totalMacros * 100
        return String(format: "%.1f%%", carbPercentage)
    }

    var proteinValue: String {
        guard totalMacros != 0 else {
                return ""
        }
        let carbPercentage = (response?.protein ?? 0.0) / totalMacros * 100
        return String(format: "%.1f%%", carbPercentage)
    }

    var calorieValue: String {
        return String(response?.calories ?? 0)
    }

    func load() {
        interactor?.loadRandomResult()
    }

    func macroValues() -> [String: Float] {
        return ["carbs": (response?.carbs ?? 0.0), "protein": (response?.protein ?? 0.0), "fat": (response?.fat ?? 0.0)]
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
