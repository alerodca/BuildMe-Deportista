//
//  ForgotPasswordViewController.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 3/6/24.
//

import UIKit
import JGProgressHUD

class ForgotPasswordViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var rememberPasswordButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    
    // MARK: - Variables
    let viewmodel = ForgotPasswordViewModel()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialConfigure()
    }

    // MARK: - Actions
    @IBAction func rememberPassword(_ sender: UIButton) {
        if let email = emailTextField.text, !email.isEmpty {
            viewmodel.sendEmail(email: email)
        } else {
            showAlert(title: "Error", message: "Debe proporcionar un correo válido", isError: true)
        }
    }
    
    @IBAction func backToLogin(_ sender: UIButton) {
        viewmodel.navigateToLogin()
    }
    
    // MARK: - Private Funcs
    private func initialConfigure() {
        view.applyBlueRedGradient()
        
        self.navigationItem.hidesBackButton = true
        
        emailTextField.delegate = self
        viewmodel.delegate = self
    }
}

// MARK: - Extension UITextFieldDelegate
extension ForgotPasswordViewController: UITextFieldDelegate {
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

// MARK: - Extension ForgotPasswordDelegate
extension ForgotPasswordViewController: ForgotPasswordProtocol {
    func navigateToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    func showAlert(title: String, message: String, isError: Bool) {
        DispatchQueue.main.async {
            let hud = JGProgressHUD()
            hud.indicatorView = isError ? JGProgressHUDErrorIndicatorView() :
            JGProgressHUDSuccessIndicatorView()
            hud.textLabel.text = title
            hud.detailTextLabel.text = message
            hud.interactionType = .blockAllTouches
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 3, animated: true)
        }
    }
}
