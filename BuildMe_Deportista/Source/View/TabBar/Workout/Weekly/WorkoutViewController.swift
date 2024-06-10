//
//  WorkoutViewController.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 28/5/24.
//

import UIKit
import Firebase
import JGProgressHUD
import FirebaseDatabase

class WorkoutViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var backView: UIView!
    
    // MARK: - Variables
    var routineLabel: UILabel!
    var routineImageView: UIImageView!
    var routineTextView: UITextView!
    var tableView: UITableView!
    var dbRef: DatabaseReference!
    var training: Training? // Definimos la propiedad training
    
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
        routineLabel = UILabel()
        routineLabel.translatesAutoresizingMaskIntoConstraints = false
        routineLabel.text = "Sin Rutina Asignada"
        routineLabel.numberOfLines = 2
        routineLabel.textAlignment = .center
        routineLabel.font = UIFont.boldSystemFont(ofSize: 23)
        routineLabel.textColor = .black
        backView.addSubview(routineLabel)
        
        // Centrar la etiqueta dentro de backView
        NSLayoutConstraint.activate([
            routineLabel.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            routineLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
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
                
                if let routine = athlete.routine {
                    self.training = routine // Establecer la propiedad training
                    self.showRoutineDetails(routine)
                } else {
                    self.training = nil // Asegurarse de que training esté vacío
                    self.hideRoutineDetails()
                }
            } catch {
                print("Error al decodificar datos: \(error)")
            }
        }) { error in
            print("Error al leer datos: \(error.localizedDescription)")
        }
    }
    
    private func showRoutineDetails(_ routine: Training) {
        routineLabel.isHidden = true
        routineImageView.isHidden = false
        routineTextView.isHidden = false
        tableView.isHidden = false
        
        routineImageView.loadImage(from: routine.image)
        routineTextView.attributedText = generateRoutineText(routine: routine)
        tableView.reloadData()
    }
    
    private func hideRoutineDetails() {
        routineLabel.isHidden = false
        routineImageView.isHidden = true
        routineTextView.isHidden = true
        tableView.isHidden = true
    }
    
    private func generateRoutineText(routine: Training) -> NSAttributedString {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .paragraphStyle: NSMutableParagraphStyle().centered()]
        let titleString = NSAttributedString(string: "Detalles\n\n", attributes: titleAttributes)
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 13)]
        let attributedString = NSMutableAttributedString()
        attributedString.append(titleString)
        attributedString.append(NSAttributedString(string: "Nombre: ", attributes: boldAttributes))
        attributedString.append(NSAttributedString(string: "\(routine.name).\n\n"))
        attributedString.append(NSAttributedString(string: "Descripción: ", attributes: boldAttributes))
        attributedString.append(NSAttributedString(string: "\(routine.description).\n\n"))
        attributedString.append(NSAttributedString(string: "Objetivos: ", attributes: boldAttributes))
        attributedString.append(NSAttributedString(string: "\(routine.goals.rawValue).\n\n"))
        attributedString.append(NSAttributedString(string: "Duración: ", attributes: boldAttributes))
        attributedString.append(NSAttributedString(string: "\(routine.durationInWeeks) semanas.\n\n"))
        attributedString.append(NSAttributedString(string: "Intensidad: ", attributes: boldAttributes))
        attributedString.append(NSAttributedString(string: "\(routine.intensity.rawValue).\n\n"))
        attributedString.append(NSAttributedString(string: "Público: ", attributes: boldAttributes))
        attributedString.append(NSAttributedString(string: "\(routine.targetAudience.rawValue).\n\n"))
        
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
extension WorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Day.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath)
        let day = Day.allCases[indexPath.row]
        
        guard let training = training else {
            cell.textLabel?.text = day.rawValue
            return cell
        }
        
        let isRestDay = training.restDays.contains(day)
        let exerciseDay = training.exerciseDays.first(where: { $0.day == day })
        
        let dayText = NSMutableAttributedString(string: day.rawValue, attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
        
        if isRestDay {
            dayText.append(NSAttributedString(string: ": Descanso"))
        } else if let exerciseDay = exerciseDay {
            let muscles = exerciseDay.muscleGroup.map { $0.rawValue }.joined(separator: ", ")
            dayText.append(NSAttributedString(string: ": \(muscles)"))
        }
        
        cell.textLabel?.attributedText = dayText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let day = Day.allCases[indexPath.row]
        
        guard let training = training else { return }
        
        let isRestDay = training.restDays.contains(day)
        
        if isRestDay {
            showAlert(title: "¡Día de Descanso!", message: "Hoy te toca descanso, mañana puedes emplear todas tus fuerzas", isError: true)
        } else if let exerciseDay = training.exerciseDays.first(where: { $0.day == day }) {
            let vc = ExerciseDayViewController(exerciseDay: exerciseDay)
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
            print(exerciseDay.toDictionary())
        }
    }
}
