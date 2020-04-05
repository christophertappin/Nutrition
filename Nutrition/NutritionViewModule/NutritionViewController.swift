//
//  ViewController.swift
//  Nutrition
//
//  Created by ChrisTappin on 05/04/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import UIKit

protocol NutritionViewControllerProtocol {

    func fetchItemSuccess()
    func fetchItemFailure()
}

class NutritionViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var carbValueLabel: UILabel!
    @IBOutlet weak var proteinValueLabel: UILabel!
    @IBOutlet weak var fatValueLabel: UILabel!
    @IBOutlet weak var calorieValueLabel: UILabel!

    var presenter: NutritionViewPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.load()
    }

    override func becomeFirstResponder() -> Bool {
        return true
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            presenter?.load()
        }
    }

    func setupView() {
        self.titleLabel.text = presenter?.title()
        self.carbValueLabel.text = presenter?.carbValue()
        self.proteinValueLabel.text = presenter?.proteinValue()
        self.fatValueLabel.text = presenter?.fatValue()
        self.calorieValueLabel.text = presenter?.calorieValue()
    }

}

extension NutritionViewController: NutritionViewControllerProtocol {

    func fetchItemSuccess() {
        setupView()
    }

    func fetchItemFailure() {
        // TODO: Show dialog
    }


}
