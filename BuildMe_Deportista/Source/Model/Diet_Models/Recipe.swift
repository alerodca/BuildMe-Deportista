//
//  Recipe.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 23/5/24.
//

import Foundation

class Recipe: Decodable {
    var name: String
    var ingredients: [String]
    var preparationTime: Int
    var servings: Int
    var image: String
    var nutritionalValues: NutritionalValues
    var mealType: MealType
    var tips: String?
    
    init(name: String, ingredients: [String], preparationTime: Int, servings: Int, image: String, nutritionalValues: NutritionalValues, mealType: MealType, tips: String?) {
        self.name = name
        self.ingredients = ingredients
        self.preparationTime = preparationTime
        self.servings = servings
        self.image = image
        self.nutritionalValues = nutritionalValues
        self.mealType = mealType
        self.tips = tips
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "ingredients": ingredients,
            "preparationTime": preparationTime,
            "servings": servings,
            "image": image,
            "nutritionalValues": nutritionalValues.toDictionary(),
            "mealType": mealType.rawValue,
            "tips": tips ?? ""
        ]
    }
}
