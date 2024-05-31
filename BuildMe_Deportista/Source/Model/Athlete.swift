//
//  Athlete.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 12/5/24.
//

import Foundation

class Athlete: Decodable {
    var name: String
    let gender: String
    let dateBirth: String
    var email: String
    var phone: String
    var username: String
    var password: String
    let trainingGoal: String
    let availableTime: String
    let location: String
    let clinicHistory: String
    let injuriesHistory: String
    let physicCondition: String
    let profileImageView: String
    var isTrainer = false
    let uid: String
    var routine: Training?
    var diet: Diet?

    init(name: String, gender: String, dateBirth: String, email: String, phone: String, username: String, password: String, trainingGoal: String, availableTime: String, location: String, clinicHistory: String, injuriesHistory: String, physicCondition: String, profileImageView: String, uid: String, routine: Training?, diet: Diet?) {
        self.name = name
        self.gender = gender
        self.dateBirth = dateBirth
        self.email = email
        self.phone = phone
        self.username = username
        self.password = password
        self.trainingGoal = trainingGoal
        self.availableTime = availableTime
        self.location = location
        self.clinicHistory = clinicHistory
        self.injuriesHistory = injuriesHistory
        self.physicCondition = physicCondition
        self.profileImageView = profileImageView
        self.uid = uid
        self.routine = routine
        self.diet = diet
    }

    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "gender": gender,
            "dateBirth": dateBirth,
            "email": email,
            "phone": phone,
            "username": username,
            "password": password,
            "trainingGoal": trainingGoal,
            "availableTime": availableTime,
            "location": location,
            "clinicHistory": clinicHistory,
            "injuriesHistory": injuriesHistory,
            "physicCondition": physicCondition,
            "profileImageView": profileImageView,
            "isTrainer": isTrainer,
            "uid": uid,
            "routine": routine?.toDictionary(),
            "diet": diet?.toDictionary()
        ]
    }
}
