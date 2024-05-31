//
//  Exercise.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 23/5/24.
//

import Foundation

class Exercise: Decodable {
    var name: String
    var image: String
    var description: String
    var reps: Int
    var sets: Int
    var muscleGroup: MuscleGroup
    
    init(name: String, image: String, description: String, reps: Int, sets: Int, muscleGroup: MuscleGroup) {
        self.name = name
        self.image = image
        self.description = description
        self.reps = reps
        self.sets = sets
        self.muscleGroup = muscleGroup
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "image": image,
            "description": description,
            "reps": reps,
            "sets": sets,
            "muscleGroup": muscleGroup.rawValue
        ]
    }
}
