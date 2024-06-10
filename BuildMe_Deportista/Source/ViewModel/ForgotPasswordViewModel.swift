//
//  ForgotPasswordViewModel.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 4/6/24.
//

import Foundation
import Firebase

protocol ForgotPasswordProtocol {
    func navigateToLogin()
    func showAlert(title: String, message: String, isError: Bool)
}

class ForgotPasswordViewModel {
    // MARK: - Variables
    var delegate: ForgotPasswordProtocol?
    
    // MARK: - Funcs
    func navigateToLogin() {
        delegate?.navigateToLogin()
    }
    
    func sendEmail(email: String) {
        let ref = Database.database().reference().child("Users/Athlete")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            var userFound = false
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let userDict = childSnapshot.value as? [String: Any],
                   let userEmail = userDict["email"] as? String, userEmail == email {
                    
                    userFound = true
                    
                    // Enviar el correo electrónico de restablecimiento de contraseña
                    Auth.auth().sendPasswordReset(withEmail: email) { error in
                        if let error = error {
                            self.delegate?.showAlert(title: "Error", message: "Error al enviar el correo electrónico de restablecimiento de contraseña: \(error.localizedDescription)", isError: true)
                        } else {
                            self.delegate?.showAlert(title: "Éxito", message: "Se ha enviado un correo para restablecer la contraseña", isError: false)
                        }
                    }
                }
            }
            
            if !userFound {
                self.delegate?.showAlert(title: "Error", message: "Este correo no aparece registrado.", isError: true)
            }
        }
    }
}

