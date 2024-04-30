//
//  Extension+UIView.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 30/4/24.
//

import UIKit

extension UIView {
    func applyBlueRedGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = UIScreen.main.bounds // Usamos el tamaño de la pantalla
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.red.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
