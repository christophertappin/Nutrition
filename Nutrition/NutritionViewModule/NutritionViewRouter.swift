//
//  NutritionViewRouter.swift
//  Nutrition
//
//  Created by ChrisTappin on 05/04/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import UIKit

protocol NutritionViewRouterProtocol {
    static func create() -> UIViewController?
}

class NutritionViewRouter: NutritionViewRouterProtocol {
    static func create() -> UIViewController? {
        let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as? NutritionViewController
        let presenter = NutritionViewPresenter()
        presenter.view = viewController

        let interactor = NutritionViewInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor

        viewController?.presenter = presenter

        return viewController
    }
}
