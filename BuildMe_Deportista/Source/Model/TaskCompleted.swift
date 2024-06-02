//
//  File.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 31/5/24.
//

import Foundation

class TaskCompleted {
    let typeTask: TaskType
    let date: Date
    let observations: String
    
    init(typeTask: TaskType, date: Date, observations: String) {
        self.typeTask = typeTask
        self.date = date
        self.observations = observations
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // Convertir la fecha a un formato de cadena
        let dateString = dateFormatter.string(from: date)
        
        // Agregar las propiedades al diccionario
        dictionary["typeTask"] = typeTask.rawValue
        dictionary["date"] = dateString
        dictionary["observations"] = observations
        
        return dictionary
    }
}
