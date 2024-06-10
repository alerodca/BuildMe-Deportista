//
//  TabBarController.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 30/4/24.
//

import UIKit
import JGProgressHUD
import FirebaseAuth
import FirebaseDatabase

protocol ControllerDelegate: AnyObject {
    func showAlert(title: String, message: String)
    func presentLoginScreen()
}

class TabBarController: UITabBarController {
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabs()
        self.checkAuthenticationAndLoadUserInfo()
    }
    
    private func checkAuthenticationAndLoadUserInfo() {
        if let currentUser = Auth.auth().currentUser {
            self.user = currentUser
            self.getAndShowCurrentUserInfo()
        } else {
            DispatchQueue.main.async {
                let controller = LoginViewController()
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }
    }
    
    private func getAndShowCurrentUserInfo() {
        guard let user = self.user else { return }
        
        let databaseRef = Database.database().reference().child("Users").child("Athlete").child(user.uid)
        
        databaseRef.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            
            if !snapshot.exists() {
                print("User data not found")
                return
            }
            
            guard let userData = snapshot.value as? [String: Any] else {
                print("Invalid user data format")
                return
            }
            
            guard let name = userData["name"] as? String else {
                print("Missing name field in user data")
                return
            }
            
            self.showAlert(title: "Bienvenido \(name)", message: "¡Qué gusto volver a verte!")
        }
    }
    
    private func setupTabs() {
        let workout = self.createNav(with: "Rutinas", and: UIImage(systemName: "figure.strengthtraining.traditional"), vc: WorkoutViewController())
        let diet = self.createNav(with: "Dietas", and: UIImage(systemName: "carrot.fill"), vc: DietViewController())
        let profile = self.createNav(with: "Perfil", and: UIImage(systemName: "person.crop.circle"), vc: ProfileViewController())
        
        self.setViewControllers([workout, diet, profile], animated: true)
        
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
        let controller = LoginViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let hud = JGProgressHUD()
            
            if let image = UIImage(named: "LogoTransparente")?.scaled(to: CGSize(width: 150.0, height: 150.0)) {
                hud.indicatorView = JGProgressHUDImageIndicatorView(image: image)
            }
            
            hud.textLabel.text = title
            hud.detailTextLabel.text = message
            hud.interactionType = .blockAllTouches
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 6, animated: true)
        }
    }
}
