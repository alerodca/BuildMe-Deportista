//
//  Extension+UIImage.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 4/6/24.
//

import UIKit

extension UIImage {
    func scaled(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        draw(in: CGRect(origin: .zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}

