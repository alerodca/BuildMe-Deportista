//
//  HealthyRecipe.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 30/4/24.
//

import Foundation

struct HealthyRecipe: Decodable, Equatable {
    static func == (lhs: HealthyRecipe, rhs: HealthyRecipe) -> Bool {
        return lhs.name == rhs.name &&
        lhs.ingredients == rhs.ingredients &&
        lhs.instructions == rhs.instructions &&
        lhs.preparationTime == rhs.preparationTime &&
        lhs.servings == rhs.servings &&
        lhs.nutritionalValue == rhs.nutritionalValue &&
        lhs.tips == rhs.tips &&
        lhs.image == rhs.image &&
        lhs.mealType == rhs.mealType
    }
    
    let name: String
    let ingredients: [String]
    let instructions: String
    let preparationTime: Int
    let servings: Int
    let nutritionalValue: NutritionalValue
    let tips: [String]
    let image: String // Nombre de la imagen
    let mealType: MealType // Tipo de comida
    
    func dictionaryRepresentation() -> NSDictionary {
        return [
            "name": name,
            "ingredients": ingredients,
            "instructions": instructions,
            "preparationTime": preparationTime,
            "servings": servings,
            "nutritionalValue": nutritionalValue.dictionaryRepresentation(),
            "tips": tips,
            "image": image,
            "mealType": mealType.rawValue
        ]
    }
}

enum MealType: String, Codable {
    case breakfast = "Desayuno"
    case lunch = "Almuerzo"
    case snack = "Merienda"
    case dinner = "Cena"
    case brunch = "Media mañana"
}

struct NutritionalValue: Codable, Equatable {
    static func == (lhs: NutritionalValue, rhs: NutritionalValue) -> Bool {
        return lhs.calories == rhs.calories &&
        lhs.proteins == rhs.proteins &&
        lhs.carbohydrates == rhs.carbohydrates &&
        lhs.fats == rhs.fats
    }
    
    let calories: Int
    let proteins: Int
    let carbohydrates: Int
    let fats: Int
    
    func dictionaryRepresentation() -> NSDictionary {
        return [
            "calories": calories,
            "proteins": proteins,
            "carbohydrates": carbohydrates,
            "fats": fats
        ]
    }
}
