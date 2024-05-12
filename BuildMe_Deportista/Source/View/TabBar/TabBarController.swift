//
//  TabBarController.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 30/4/24.
//

import UIKit
import FirebaseAuth

protocol ControllerDelegate: AnyObject {
    func showAlert(title: String, message: String)
    func presentLoginScreen()
}

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTabs()
        
        isUserLogged()
    }
    
    private func isUserLogged() {
        DispatchQueue.main.async {
            if let uid = Auth.auth().currentUser?.uid {
                self.showAlert(title: "User", message: uid)
            } else {
                self.presentLoginScreen()
            }
        }
    }
    
    private func setupTabs() {
        let workout = self.createNav(with: "Rutinas", and: UIImage(systemName: "figure.strengthtraining.traditional"), vc: WorkoutViewController())
        let diet = self.createNav(with: "Dietas", and: UIImage(systemName: "carrot.fill"), vc: DietViewController())
        let profile = self.createNav(with: "Perfil", and: UIImage(systemName: "person.crop.circle"), vc: ProfileViewController())
        
        self.setViewControllers([workout,diet,profile], animated: true)
        
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = .black
        self.tabBar.unselectedItemTintColor = .lightGray
    }
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        return nav
    }
}

extension TabBarController: ControllerDelegate {
    func presentLoginScreen() {
        let controller = SignupViewController() //LoginViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
