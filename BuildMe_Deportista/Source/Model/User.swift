//
//  User.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 30/4/24.
//

import Foundation

struct User: Decodable {
    var name: String
    var username: String
    var email: String
    var password: String
    var uid: String
    var profileImageURL: String
    
    func toDictionary() -> [String: String] {
        return [
            "name": name,
            "username": username,
            "email": email,
            "password": password,
            "uid": uid,
            "profileImageURL": profileImageURL
        ]
    }
}
