//
//  Extension+String.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 30/4/24.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    static func removeOptional(from string: String) -> String {
        let regex = try! NSRegularExpression(pattern: #"Optional\("(.*)"\)"#)
        let range = NSRange(location: 0, length: string.utf16.count)
        let formattedString = regex.stringByReplacingMatches(in: string, range: range, withTemplate: "$1")
        return formattedString
    }
}
