//
//  SignupViewModel.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 12/5/24.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import CryptoKit

protocol ImagePickerDelegate: AnyObject {
    func presentImagePicker()
    func disableButtons()
    func enableButtons()
}

class SignupViewModel: NSObject {
    
    // MARK: - Variables
    var name: String?
    var gender: String?
    var dateBirth: String?
    var email: String?
    var phone: String?
    var username: String?
    var password: String?
    var clinicHistory: String?
    var injuryHistory: String?
    var trainingGoal: String?
    var schedule: String?
    var geographicAvailable: String?
    var physicCondition: String?
    weak var delegate: AuthControllerDelegate?
    weak var pickerDelegate: ImagePickerDelegate?
    var errorMessage = ""
    var image: UIImage?
    var imageURL: String?
    let storage = Storage.storage()
    
    // MARK: - Functions
    func setName(text: String?) {
        if text != "" {
            self.name = text
        }
    }
    func setGender(gender: String?) {
        self.gender = gender
    }
    func setDateBirth(selectedDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let formattedDate = dateFormatter.string(from: selectedDate)
        self.dateBirth = formattedDate
    }
    func setEmail(text: String?) {
        if text != "" {
            self.email = text
        }
    }
    func setPhone(text: String?) {
        if text != "" {
            self.phone = "+34 \(text)"
        }
    }
    func setUsername(text: String?) {
        if text != "" {
            self.username = text
        }
    }
    func setPassword(text: String?) {
        if text != "" {
            self.password = text
        }
    }
    func setClinicHistory(text: String?) {
        if text != "" {
            self.clinicHistory = text
        }
    }
    func setinjuryHistory(text: String?) {
        if text != "" {
            self.injuryHistory = text
        }
    }
    func setTrainingGoal(text: String) {
        self.trainingGoal = text
    }
    func setSchedule(text: String) {
        self.schedule = text
    }
    func setGeographicAvailable(text: String) {
        self.geographicAvailable = text
    }
    func setPhysicCondition(text: String) {
        self.physicCondition = text
    }
    func selectImage() {
        pickerDelegate?.presentImagePicker()
    }
    func saveImage(_ image: UIImage) {
        self.image = image
        
        uploadImageToFirebase(image: image, completion: { imageUrl in
            self.imageURL = imageUrl
            self.delegate?.showAlert(title: "Imagen", message: "Imagen guardada.")
        })
    }
    func popToLogin() {
        delegate?.navigate()
    }
    
    func createAccount() {
        pickerDelegate?.disableButtons()
        guard let name = name, !name.isEmpty,
              let gender = gender, !gender.isEmpty,
              let dateBirth = dateBirth, !dateBirth.isEmpty,
              let email = email, !email.isEmpty, email.isValidEmail(),
              let phone = phone, !phone.isEmpty,
              let username = username, !username.isEmpty,
              let password = password, !password.isEmpty,
              let trainingGoal = trainingGoal, !trainingGoal.isEmpty,
              let schedule = schedule, !schedule.isEmpty,
              let geographicAvailable = geographicAvailable, !geographicAvailable.isEmpty,
              let clinicHistory = clinicHistory, !clinicHistory.isEmpty,
              let injuryHistory = injuryHistory, !clinicHistory.isEmpty,
              let physicCondition = physicCondition, !physicCondition.isEmpty else {
            delegate?.showAlert(title: "Error", message: "Todos los campos deben estar completos.")
            pickerDelegate?.enableButtons()
            return
        }
        
        guard let profileImageURL = imageURL else {
            delegate?.showAlert(title: "Error", message: "Debes seleccionar una imagen de perfil")
            pickerDelegate?.enableButtons()
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showError(error: error as! AuthErrorCode)
            } else {
                guard let uid = authResult?.user.uid else {
                    self.delegate?.showAlert(title: "Error", message: "No se pudo obtener el UID del usuario.")
                    self.pickerDelegate?.enableButtons()
                    return
                }
                if let passwordEncrypted = self.encryptPassword(password: password) {
                    let user = Athlete(
                        name: name,
                        gender: gender,
                        dateBirth: dateBirth,
                        email: email,
                        phone: phone,
                        username: username,
                        password: password,
                        trainingGoal: trainingGoal,
                        availableTime: schedule,
                        location: geographicAvailable,
                        clinicHistory: clinicHistory,
                        injuriesHistory: injuryHistory,
                        physicCondition: physicCondition,
                        profileImageView: profileImageURL,
                        uid: uid,
                        routine: nil,
                        diet: nil)
                    self.saveUserToDatabase(athlete: user)
                    self.pickerDelegate?.enableButtons()
                    self.delegate?.authComplete()
                } else {
                    self.delegate?.showAlert(title: "Error", message: "Hubo un error al encriptar la contraseña.")
                    self.pickerDelegate?.enableButtons()
                }
            }
        }
    }
    
    // MARK: - Enum
    enum Gender: String {
        case male = "Masculino"
        case female = "Femenino"
    }
    
    // MARK: - Private Functions
    private func uploadImageToFirebase(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Error al convertir la imagen a data")
            completion(nil)
            return
        }
        
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("profile_images").child(UUID().uuidString + ".jpg")
        
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            guard let _ = metadata else {
                print("Error al cargar la imagen:", error?.localizedDescription ?? "Error desconocido")
                completion(nil)
                return
            }
            
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Error al obtener la URL de descarga:", error.localizedDescription)
                    completion(nil)
                } else if let downloadURL = url {
                    completion(downloadURL.absoluteString)
                } else {
                    print("No se pudo obtener la URL de descarga")
                    completion(nil)
                }
            }
        }
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
        delegate?.showAlert(title: "Error", message: errorMessage)
    }
    
    private func encryptPassword(password: String) -> String? {
        guard let password = password.data(using: .utf8) else { return nil }
        let hashed = SHA256.hash(data: password)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
    
    private func saveUserToDatabase(athlete: Athlete) {
        let databaseRef = Database.database().reference().child(Constants.athleteChild).child(athlete.uid)
        let userDictionary = athlete.toDictionary()
        databaseRef.setValue(userDictionary) { error, refDatabase in
            if let error = error {
                self.delegate?.showAlert(title: "Error", message: "Hubo un error al guardar los datos.")
            }
        }
    }
}

