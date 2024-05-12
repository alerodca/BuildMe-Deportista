//
//  ProfileViewModel.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 30/4/24.
//

import Foundation
import Firebase
import FirebaseDatabase


protocol ProfileDelegate {
    func presentLogout()
    func editProfile()
    func presentLoginScreen()
    func showAlert(title: String, message: String)
    func updateUser(user: User)
}

class ProfileViewModel {
    
    // MARK: - Variables
    var delegate: ProfileDelegate?
    let db = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    var actualUser: User?
    
    init() {
        observeAuthState()
    }
    
    // MARK: - Functions
    func observeAuthState() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user { // user.uid
                let ref = self.db.child(Constants.athleteChild).child(user.uid)
                ref.observe(.value) { (snapshot) in
                    guard let value = snapshot.value as? [String: Any] else { return }
                    if let user = self.castToUser(from: value) {
                        self.actualUser = user
                        self.delegate?.updateUser(user: user)
                        print("Usuario logueado: \(user.name)")
                    }
                }
            } else {
                print("No hay usuario actualmente autenticado.")
            }
        }
    }
    
    func logout() {
        delegate?.presentLogout()
    }
    
    func getUser(completion: @escaping (User?) -> Void) {
        guard let uid = uid else { return completion(nil) }
        let ref = db.child(Constants.athleteChild).child(uid)
        ref.observe(.value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            let user = self.castToUser(from: value)
            self.actualUser = user
            completion(user)
        }
    }
    
    func editProfile() {
        delegate?.editProfile()
    }
    
    func makeLogout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out...")
        }
        if Auth.auth().currentUser?.uid == nil {
            delegate?.presentLoginScreen()
        }
    }
    
    func updateProfile(name: String?, username: String?, email: String?) {
        if (name != actualUser?.name &&
            username != actualUser?.username &&
            email != actualUser?.email) {
            guard var user = self.actualUser else { return }
            
            guard let name = name,
                  let username = username,
                  let email = email,
                  email.isValidEmail() else { return }
            
            user.name = name
            user.username = username
            user.email = email
            
            let userToDictionary = user.toDictionary()
            
            if userToDictionary != nil {
                db.child(Constants.athleteChild).child(uid!).updateChildValues(userToDictionary) { error, _ in
                    if let error = error {
                        print("Error actualizando datos: \(error.localizedDescription)")
                    } else {
                        self.delegate?.showAlert(title: "Actualizar Usuario", message: "Cambios Actualizados.")
                    }
                }
            } else {
                print("userdictionary es nil")
            }
        } else {
            self.delegate?.showAlert(title: "Actualizar Usuario", message: "No ha habido ningún cambio.")
        }
    }
    
    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: actualUser!.email) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.delegate?.showAlert(title: "Cambio de Contraseña", message: "Se ha enviado un mail a tu correo para cambiar la contraseña.")
            }
        }
    }
    
    // MARK: - Private Funcs
    private func castToUser(from dictionary: [String: Any]) -> User? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            let decoder = JSONDecoder()
            let user = try decoder.decode(User.self, from: data)
            return user
        } catch {
            print("Error casting data to User: \(error)")
            return nil
        }
    }
}
