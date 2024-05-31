//
//  Diet.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 23/5/24.
//

import Foundation

class Diet: Decodable {
    var name: String
    var image: String
    var description: String
    var durationInWeeks: Int
    var days: [DietDay]
    
    init(name: String, image: String, description: String, durationInWeeks: Int, days: [DietDay]) {
        self.name = name
        self.image = image
        self.description = description
        self.durationInWeeks = durationInWeeks
        self.days = days
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "image": image,
            "description": description,
            "durationInWeeks": durationInWeeks,
            "days": days.map { $0.toDictionary() }
        ]
    }
}
