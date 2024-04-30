//
//  LoginViewController.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 30/4/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextFild: UITextField!
    
    // MARK: - Variables
    let viewmodel = LoginViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialConfigure()
        
    }
    
    // MARK: - Functions
    private func initialConfigure() {
        view.applyBlueRedGradient()
        usernameTextField.setupLeftSideImage(systemImageNamed: "envelope")
        passwordTextFild.setupLeftSideImage(systemImageNamed: "lock")
        
        usernameTextField.delegate = self
        passwordTextFild.delegate = self
        viewmodel.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func loginWithEmailAndPassword(_ sender: UIButton) {
        viewmodel.login(email: usernameTextField.text, password: passwordTextFild.text)
    }
    @IBAction func navigateToCreateAccount(_ sender: UIButton) {
        viewmodel.navigatoToSignUp()
    }
}

// MARK: - Extension UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    // Este método se llama cuando se toca el botón de retorno en el teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Oculta el teclado
        textField.resignFirstResponder()
        return true
    }
    // Este método se llama cuando se toca fuera de los text fields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Oculta el teclado
        view.endEditing(true)
    }
}

// MARK: - Extension LoginViewControllerDelegate
extension LoginViewController: AuthControllerDelegate {
    func authComplete() {
        dismiss(animated: true)
    }
    
    func navigate() {
        let signUp = SignupViewController()
        navigationController?.pushViewController(signUp, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
