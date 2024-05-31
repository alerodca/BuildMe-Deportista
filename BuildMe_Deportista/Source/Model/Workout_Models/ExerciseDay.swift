//
//  ExerciseDay.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 23/5/24.
//

import Foundation

class ExerciseDay: Decodable {
    var day: Day
    var muscleGroup: [MuscleGroup]
    var exercises: [Exercise]
    
    init(day: Day, muscleGroup: [MuscleGroup], exercises: [Exercise]) {
        self.day = day
        self.muscleGroup = muscleGroup
        self.exercises = exercises
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "day": day.rawValue,
            "muscleGroup": muscleGroup.map { $0.rawValue },
            "exercises": exercises.map { $0.toDictionary() }
        ]
    }
}
