//
//  NutritionalValues.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 23/5/24.
//

import Foundation

class NutritionalValues: Decodable {
    var calories: Double
    var protein: Double
    var carbohydrates: Double
    var fat: Double
    
    init(calories: Double, protein: Double, carbohydrates: Double, fat: Double) {
        self.calories = calories
        self.protein = protein
        self.carbohydrates = carbohydrates
        self.fat = fat
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "calories": calories,
            "protein": protein,
            "carbohydrates": carbohydrates,
            "fat": fat
        ]
    }
}
