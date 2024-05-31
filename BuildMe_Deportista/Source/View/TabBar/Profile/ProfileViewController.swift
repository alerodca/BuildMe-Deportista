//
//  ProfileViewController.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 30/4/24.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var subViewProfile: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    // MARK: - Variables
    let viewmodel = ProfileViewModel()
    var user: Athlete?
    var isEditingProfile = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
      super.viewDidLoad()
      
      viewmodel.getUser { [weak self] user in
        guard let self = self, let user = user else { return }
        self.user = user
        DispatchQueue.main.async {
          self.confUser() // Llama solo si user tiene un valor
        }
      }
      
      confInitial()
    }
    
    // MARK: - Functions
    private func confInitial() {
        view.applyBlueRedGradient()
        subViewProfile.layer.cornerRadius = 15
        confProfileImageView()
        viewmodel.delegate = self
        nameTextField.setupLeftSideImage(systemImageNamed: "person")
        usernameTextField.setupLeftSideImage(systemImageNamed: "person.crop.square")
        emailTextField.setupLeftSideImage(systemImageNamed: "envelope")
        nameTextField.isEnabled = false
        usernameTextField.isEnabled = false
        emailTextField.isEnabled = false
    }
    private func confProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 7
    }
    private func confUser() {
        profileImageView.loadImage(from: user?.profileImageView)
        nameTextField.text = user?.name
        usernameTextField.text = user?.username
        emailTextField.text = user?.email
    }
    // MARK: - Actions
    @IBAction func changePasswordAction(_ sender: UIButton) {
        viewmodel.resetPassword()
    }
    @IBAction func editProfileAction(_ sender: Any) {
        viewmodel.editProfile()
    }
    @IBAction func logoutAction(_ sender: UIButton) {
        viewmodel.logout()
    }
}

extension ProfileViewController: ProfileDelegate {
    func updateUser(user: Athlete) {
        print("Implementando user en el viewcontroller")
        self.user = user
        DispatchQueue.main.async {
          self.confUser()
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func presentLoginScreen() {
        let controller = LoginViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    func editProfile() {
        
        isEditingProfile.toggle()
        
        if isEditingProfile {
            nameTextField.isEnabled = true
            usernameTextField.isEnabled = true
            changePasswordButton.isEnabled = false
            logoutButton.isEnabled = false
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 20)
            ]
            let attributedTitle = NSAttributedString(string: "Actualizar usuario", attributes: attributes)
            editProfileButton.setAttributedTitle(attributedTitle, for: .normal)
        } else {
            nameTextField.isEnabled = false
            usernameTextField.isEnabled = false
            changePasswordButton.isEnabled = true
            logoutButton.isEnabled = true
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 20)
            ]
            let attributedTitle = NSAttributedString(string: "Editar Perfil", attributes: attributes)
            editProfileButton.setAttributedTitle(attributedTitle, for: .normal)
            
            viewmodel.updateProfile(name: nameTextField.text, username: usernameTextField.text, email: emailTextField.text)
        }
    }
    
    func presentLogout() {
        let alert = UIAlertController(title: nil, message: "¿Estás seguro de que quieres cerrar sesión?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cerrar Sesión", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.viewmodel.makeLogout()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
