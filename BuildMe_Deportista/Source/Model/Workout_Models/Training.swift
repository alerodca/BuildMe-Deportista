//
//  Training.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 23/5/24.
//

import Foundation

class Training: Decodable {
    var name: String
    var image: String
    var description: String
    var targetAudience: TargetAudience
    var intensity: Intensity
    var durationInWeeks: Int
    var restDays: [Day]
    var exerciseDays: [ExerciseDay]
    var goals: Goals
    
    init(name: String, image: String, description: String, targetAudience: TargetAudience, intensity: Intensity, durationInWeeks: Int, restDays: [Day], exerciseDays: [ExerciseDay], goals: Goals) {
        self.name = name
        self.image = image
        self.description = description
        self.targetAudience = targetAudience
        self.intensity = intensity
        self.durationInWeeks = durationInWeeks
        self.restDays = restDays
        self.exerciseDays = exerciseDays
        self.goals = goals
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "image": image,
            "description": description,
            "targetAudience": targetAudience.rawValue,
            "intensity": intensity.rawValue,
            "durationInWeeks": durationInWeeks,
            "restDays": restDays.map { $0.rawValue },
            "exerciseDays": exerciseDays.map { $0.toDictionary() },
            "goals": goals.rawValue
        ]
    }
}
