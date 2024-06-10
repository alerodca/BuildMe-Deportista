//
//  LoginViewModel.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 30/4/24.
//

import Foundation
import Firebase

protocol AuthControllerDelegate: AnyObject {
    func showAlert(title: String, message: String, isError: Bool)
    func navigate()
    func authComplete()
    func showIndicator()
    func hideIndicator()
    func navigateToForgotPassword()
}

class LoginViewModel {
    
    // MARK: - Variables
    weak var delegate: AuthControllerDelegate?
    var errorMessage = ""
    
    // MARK: - Functions
    func login(email: String?, password: String?) {
        delegate?.showIndicator()

        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
            delegate?.hideIndicator()
            delegate?.showAlert(title: "Error", message: "Por favor ingresa un email y una contraseña válidos", isError: true)
            return
        }

        // Check user type (athlete or trainer) using Firebase Realtime Database
        let databaseRef = Database.database().reference().child(Constants.athleteChild) // Assuming Constants.trainerChild points to the trainer node

        databaseRef.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            self.delegate?.hideIndicator() // Hide indicator after any Database operation

            if !snapshot.exists() {
                self.delegate?.showAlert(title: "Error", message: "No se encontraron datos de usuarios en la base de datos", isError: true)
                return
            }

            var isTrainer = false
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let userData = childSnapshot.value as? [String: Any],
                   let userEmail = userData["email"] as? String,
                   userEmail == email {
                    isTrainer = true
                    break
                }
            }

            if isTrainer {
                // Attempt authentication if user is a trainer
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                    guard let self = self else { return }

                    if let error = error {
                        self.showError(error: error as! AuthErrorCode)
                    } else {
                        self.delegate?.authComplete() // Successful login as trainer
                    }
                }
            } else {
                self.delegate?.showAlert(title: "Error", message: "Para acceder a la app debe ser un Deporstista", isError: true)
            }
        }
    }
    
    func navigatoToSignUp() {
        delegate?.navigate()
    }
    
    private func showError(error: AuthErrorCode) {
        switch error {
        case AuthErrorCode.invalidEmail:
            errorMessage = "Correo electrónico inválido."
        case AuthErrorCode.wrongPassword:
            errorMessage = "Contraseña incorrecta."
        case AuthErrorCode.userNotFound:
            errorMessage = "El usuario no está registrado."
        case AuthErrorCode.userDisabled:
            errorMessage = "El usuario ha sido inhabilitado."
        case AuthErrorCode.tooManyRequests:
            errorMessage = "Demasiados intentos. Inténtalo de nuevo más tarde."
        case AuthErrorCode.networkError:
            errorMessage = "Error de red. Por favor, verifica tu conexión a internet."
        case AuthErrorCode.operationNotAllowed:
            errorMessage = "Esta operación no está permitida."
        case AuthErrorCode.emailAlreadyInUse:
            errorMessage = "El correo electrónico ya está en uso."
        case AuthErrorCode.weakPassword:
            errorMessage = "La contraseña es demasiado débil."
        default:
            errorMessage = "Se ha producido un error inesperado. Por favor, inténtalo de nuevo más tarde."
        }
        delegate?.showAlert(title: "Error", message: errorMessage, isError: true)
    }
}
