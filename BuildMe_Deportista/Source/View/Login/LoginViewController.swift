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
    var iconClick = false
    var imageIcon = UIImageView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialConfigure()
        
    }
    
    // MARK: - Functions
    private func initialConfigure() {
        view.applyBlueRedGradient()
        
        imageIcon.image = UIImage(named: "closeEye")
        let contentView = UIView()
        contentView.addSubview(imageIcon)
        contentView.frame = CGRect(
            x: 0,
            y: 0,
            width: UIImage(named: "eyeClose")!.size.width,
            height: UIImage(named: "eyeClose")!.size.height
        )
        imageIcon.frame = CGRect(
            x: -10,
            y: 0,
            width: UIImage(named: "eyeClose")!.size.width,
            height: UIImage(named: "eyeClose")!.size.height
        )
        passwordTextFild.rightView = contentView
        passwordTextFild.rightViewMode = .always
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageIcon.isUserInteractionEnabled = true
        imageIcon.addGestureRecognizer(tapGestureRecognizer)
        
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
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        if iconClick {
            iconClick = false
            tappedImage.image = UIImage(named: "eyeOpen")
            passwordTextFild.isSecureTextEntry = false
        } else {
            iconClick = true
            tappedImage.image = UIImage(named: "eyeClose")
            passwordTextFild.isSecureTextEntry = true
        }
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
