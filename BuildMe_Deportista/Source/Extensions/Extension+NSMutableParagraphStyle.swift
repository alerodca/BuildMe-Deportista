//
//  Extension+NSMutableParagraphStyle.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 27/5/24.
//

import UIKit

extension NSMutableParagraphStyle {
    func centered() -> NSMutableParagraphStyle {
        let centeredStyle = NSMutableParagraphStyle()
        centeredStyle.alignment = .center
        return centeredStyle
    }
}
