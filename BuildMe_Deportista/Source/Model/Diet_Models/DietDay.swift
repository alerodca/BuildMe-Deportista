//
//  DietDay.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 23/5/24.
//

import Foundation

class DietDay: Decodable {
    var day: Day
    var breakfast: Recipe
    var lunch: Recipe
    var snack: Recipe
    var dinner: Recipe
    var midMorningSnack: Recipe
    var nutritionalGoals: NutritionalValues
    
    init(day: Day, breakfast: Recipe, lunch: Recipe, snack: Recipe, dinner: Recipe, midMorningSnack: Recipe, nutritionalGoals: NutritionalValues) {
        self.day = day
        self.breakfast = breakfast
        self.lunch = lunch
        self.snack = snack
        self.dinner = dinner
        self.midMorningSnack = midMorningSnack
        self.nutritionalGoals = nutritionalGoals
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "day": day.rawValue,
            "breakfast": breakfast.toDictionary(),
            "lunch": lunch.toDictionary(),
            "snack": snack.toDictionary(),
            "dinner": dinner.toDictionary(),
            "midMorningSnack": midMorningSnack.toDictionary(),
            "nutritionalGoals": nutritionalGoals.toDictionary()
        ]
    }
}
