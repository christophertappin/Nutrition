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

    let macroColours = ["protein": UIColor(named: "Green")?.cgColor,
                        "carbs": UIColor(named: "Red")?.cgColor,
                        "fat": UIColor(named: "Blue")?.cgColor]

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var carbValueLabel: UILabel!
    @IBOutlet weak var proteinValueLabel: UILabel!
    @IBOutlet weak var fatValueLabel: UILabel!
    @IBOutlet weak var calorieValueLabel: UILabel!
    @IBOutlet weak var calorieView: UIView!

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
        drawMacroChart(values: presenter?.macroValues().mapValues { value in
            CGFloat(value)
            } ?? [:])
    }

    func drawMacroChart(values: [String: CGFloat]) {
        calorieView.layer.sublayers?.forEach { if type(of: $0) == CAShapeLayer.self {
            $0.removeFromSuperlayer()
        }}
        let total = values.values.reduce(0, +)

        var startAngle: CGFloat = 0.0

        for (key, value) in values {
            let valuePercentage: CGFloat = value / total
            let endAngle = 360.0 * valuePercentage + startAngle

            let arc = drawArc(startAngle: startAngle, endAngle: endAngle)
            arc.strokeColor = macroColours[key]!
            calorieView.layer.addSublayer(arc)
            startAngle = endAngle
        }
    }

    func drawArc(startAngle: CGFloat, endAngle: CGFloat) -> CAShapeLayer {
        let midX = calorieView.bounds.midX
        let midY = calorieView.bounds.midY
        let radius = calorieView.bounds.width / 2

        let startRad = startAngle * .pi / 180
        let endRad = endAngle * .pi / 180

        let arc = CAShapeLayer()
        arc.path = UIBezierPath(arcCenter: CGPoint(x: midX, y: midY),
                                radius: radius,
                                startAngle: startRad,
                                endAngle: endRad,
                                clockwise: true).cgPath
        arc.fillColor = UIColor.clear.cgColor
        arc.lineWidth = 30

        return arc
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
