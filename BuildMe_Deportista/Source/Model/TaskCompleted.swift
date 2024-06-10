//
//  File.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 31/5/24.
//

import Foundation

class TaskCompleted: Codable {
    let typeTask: TaskType
    let date: Date
    let observations: String
    let uid: String
    let taskUid: String
    
    enum CodingKeys: String, CodingKey {
        case typeTask
        case date
        case observations
        case uid
        case taskUid
    }
    
    init(typeTask: TaskType, date: Date, observations: String, uid: String, taskUid: String) {
        self.typeTask = typeTask
        self.date = date
        self.observations = observations
        self.uid = uid
        self.taskUid = taskUid
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Convertir la fecha a un formato de cadena
        let dateString = dateFormatter.string(from: date)
        
        // Agregar las propiedades al diccionario
        dictionary["typeTask"] = typeTask.rawValue
        dictionary["date"] = dateString
        dictionary["observations"] = observations
        dictionary["uid"] = uid
        dictionary["taskUid"] = taskUid
        
        return dictionary
    }
}
