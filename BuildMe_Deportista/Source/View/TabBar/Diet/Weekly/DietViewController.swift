//
//  DietViewController.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 30/4/24.
//

import UIKit
import Firebase
import JGProgressHUD
import FirebaseDatabase

class DietViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var backView: UIView!
    
    // MARK: - Variables
    var dietLabel: UILabel!
    var routineImageView: UIImageView!
    var routineTextView: UITextView!
    var tableView: UITableView!
    var dbRef: DatabaseReference!
    var diet: Diet? // Definimos la propiedad training
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialConfigure()
        setupRoutineLabel()
        setupRoutineDetails()
        setupDatabaseObserver()
    }
    
    // MARK: - Private Functions
    private func initialConfigure() {
        view.applyBlueRedGradient()
        backView.layer.cornerRadius = 15
        backView.layer.masksToBounds = true
    }
    
    private func setupRoutineLabel() {
        dietLabel = UILabel()
        dietLabel.translatesAutoresizingMaskIntoConstraints = false
        dietLabel.text = "Sin Dieta Asignada"
        dietLabel.numberOfLines = 2
        dietLabel.textAlignment = .center
        dietLabel.font = UIFont.boldSystemFont(ofSize: 23)
        dietLabel.textColor = .black
        backView.addSubview(dietLabel)
        
        // Centrar la etiqueta dentro de backView
        NSLayoutConstraint.activate([
            dietLabel.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            dietLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            
        ])
        
    }
    
    private func setupRoutineDetails() {
        routineImageView = UIImageView()
        routineImageView.translatesAutoresizingMaskIntoConstraints = false
        routineImageView.contentMode = .scaleAspectFit
        routineImageView.layer.cornerRadius = 15
        routineImageView.layer.masksToBounds = true
        backView.addSubview(routineImageView)
        
        routineTextView = UITextView()
        routineTextView.translatesAutoresizingMaskIntoConstraints = false
        routineTextView.isEditable = false
        routineTextView.isScrollEnabled = true
        routineTextView.layer.borderColor = UIColor.black.cgColor
        routineTextView.layer.borderWidth = 1
        routineTextView.layer.cornerRadius = 15
        backView.addSubview(routineTextView)
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DayCell")
        backView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            routineImageView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 16),
            routineImageView.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            routineImageView.widthAnchor.constraint(equalToConstant: 100),
            routineImageView.heightAnchor.constraint(equalToConstant: 100),
            
            routineTextView.topAnchor.constraint(equalTo: routineImageView.bottomAnchor, constant: 16),
            routineTextView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),
            routineTextView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
            routineTextView.heightAnchor.constraint(equalToConstant: 200),
            
            tableView.topAnchor.constraint(equalTo: routineTextView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -16)
        ])
        
        // Inicialmente ocultar los detalles de la rutina
        routineImageView.isHidden = true
        routineTextView.isHidden = true
        tableView.isHidden = true
    }
    
    private func setupDatabaseObserver() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Usuario no autenticado.")
            return
        }
        
        // Apuntar al nodo `Users/Athlete/uid`
        dbRef = Database.database().reference().child("Users").child("Athlete").child(uid)
        
        // Configurar el observador
        dbRef.observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else { return }
            do {
                let data = try JSONSerialization.data(withJSONObject: value, options: [])
                let decoder = JSONDecoder()
                let athlete = try decoder.decode(Athlete.self, from: data)
                
                if let diet = athlete.diet {
                    self.diet = diet // Establecer la propiedad training
                    self.showRoutineDetails(diet)
                } else {
                    self.diet = nil // Asegurarse de que training esté vacío
                    self.hideRoutineDetails()
                }
            } catch {
                print("Error al decodificar datos: \(error)")
            }
        }) { error in
            print("Error al leer datos: \(error.localizedDescription)")
        }
    }
    
    private func showRoutineDetails(_ diet: Diet) {
        dietLabel.isHidden = true
        routineImageView.isHidden = false
        routineTextView.isHidden = false
        tableView.isHidden = false
        
        routineImageView.loadImage(from: diet.image)
        routineTextView.attributedText = generateRoutineText(diet: diet)
        tableView.reloadData()
    }
    
    private func hideRoutineDetails() {
        dietLabel.isHidden = false
        routineImageView.isHidden = true
        routineTextView.isHidden = true
        tableView.isHidden = true
    }
    
    private func generateRoutineText(diet: Diet) -> NSAttributedString {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .paragraphStyle: NSMutableParagraphStyle().centered()]
        let titleString = NSAttributedString(string: "Detalles\n\n", attributes: titleAttributes)
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18)]
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18)]
        let attributedString = NSMutableAttributedString()
        attributedString.append(titleString)
        attributedString.append(NSAttributedString(string: "Nombre: ", attributes: boldAttributes))
        attributedString.append(NSAttributedString(string: "\(diet.name).\n\n", attributes: regularAttributes))
        attributedString.append(NSAttributedString(string: "Descripción: ", attributes: boldAttributes))
        attributedString.append(NSAttributedString(string: "\(diet.description).\n\n", attributes: regularAttributes))
        attributedString.append(NSAttributedString(string: "Duración: ", attributes: boldAttributes))
        attributedString.append(NSAttributedString(string: "\(diet.durationInWeeks) semanas.\n\n", attributes: regularAttributes))
        return attributedString
    }
    
    private func showAlert(title: String, message: String, isError: Bool) {
        DispatchQueue.main.async {
            let hud = JGProgressHUD()
            hud.indicatorView = isError ? JGProgressHUDErrorIndicatorView() : JGProgressHUDSuccessIndicatorView()
            hud.textLabel.text = title
            hud.detailTextLabel.text = message
            hud.interactionType = .blockAllTouches
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 3, animated: true)
        }
    }
}

// MARK: - Extension UITableViewDelegate, UITableViewDataSource
extension DietViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Day.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath)
        let day = Day.allCases[indexPath.row]
        
        guard let diet = diet else {
            cell.textLabel?.text = day.rawValue
            return cell
        }
        
        let dayText = NSMutableAttributedString(string: day.rawValue, attributes: [.font: UIFont.boldSystemFont(ofSize: 20)])
        
        cell.textLabel?.attributedText = dayText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let diet = diet, indexPath.row < diet.days.count else { return }

        let dietDay = diet.days[indexPath.row]
        let vc = DietDayViewController(dietDay: dietDay)
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)

        print("Día: \(dietDay.day.rawValue)")
    }


}
