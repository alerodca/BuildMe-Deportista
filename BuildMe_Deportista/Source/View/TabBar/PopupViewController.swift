//
//  PopupViewController.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 30/5/24.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
import FirebaseDatabase

class PopupViewController: UIViewController {
    
    // MARK: - Properties
    private let textView = UITextView()
    private let datePicker = UIDatePicker()
    private let placeholderText = "Si tienes alguna observación puedes ponerla aquí..."
    let placeholderColor = UIColor.lightGray
    let typeTask: TaskType
    
    // MARK: - Constructor
    init(typeTask: TaskType) {
        self.typeTask = typeTask
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        configureTextview()
    }
    
    
    
    // MARK: - Private Methods
    private func setupViews() {
        // Configurar el fondo semitransparente
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Configurar la vista del popup
        let popupView = UIView()
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.backgroundColor = .white
        popupView.layer.cornerRadius = 10
        view.addSubview(popupView)
        
        // Agregar constraints para centrar el popupView y definir su tamaño
        NSLayoutConstraint.activate([
            popupView.widthAnchor.constraint(equalToConstant: 300),
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Título en negrita
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "¡Guardar como completado!"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.textAlignment = .center
        popupView.addSubview(titleLabel)
        
        // TextField
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .justified
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5.0
        popupView.addSubview(textView)
        
        // DatePicker compacto
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .compact
        }
        popupView.addSubview(datePicker)
        
        // Botón rojo (Cancelar)
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancelar", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = .red
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        cancelButton.layer.cornerRadius = 10 // Agregar borde al botón
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        popupView.addSubview(cancelButton)
        
        // Botón azul (Guardar)
        let saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Guardar", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .blue
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        saveButton.layer.cornerRadius = 10 // Agregar borde al botón
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        popupView.addSubview(saveButton)
        
        // Agregar constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -16),
            
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -16),
            textView.heightAnchor.constraint(equalToConstant: 80),
            
            datePicker.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            datePicker.centerXAnchor.constraint(equalTo: popupView.centerXAnchor), // Centrar horizontalmente
            
            cancelButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 16),
            cancelButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -16),
            cancelButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -8),
            cancelButton.widthAnchor.constraint(equalTo: saveButton.widthAnchor, multiplier: 1),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            
            saveButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 16),
            saveButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            saveButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -16),
            saveButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -16),
            saveButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 1),
            saveButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor)
        ])
    }
    
    private func configureTextview() {
        textView.delegate = self
        textView.text = placeholderText
        textView.textColor = placeholderColor
    }
    
    // MARK: - Button Actions
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        var enteredText = textView.text ?? ""
        if enteredText == placeholderText || enteredText == "" {
            enteredText = "Ninguna observación asignada"
        }
        
        let selectedDate = datePicker.date
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Error: No hay ningún usuario autenticado")
            return
        }
        
        // Formatear la fecha
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Formato de fecha deseado
        let formattedDate = dateFormatter.string(from: selectedDate)
        
        print(self.typeTask)
        
        let taskCompleted = TaskCompleted(typeTask: self.typeTask, date: selectedDate, observations: enteredText, uid: uid)
        let taskDictionary = taskCompleted.toDictionary()
        
        print(taskDictionary)
        
        // Obtener una referencia a la base de datos
        let databaseRef = Database.database().reference()
        
        // Acceder al nodo "CompletedTasks" y traer todos los datos
        databaseRef.child("CompletedTasks").observeSingleEvent(of: .value) { (snapshot) in
            var duplicateFound = false
            
            // Iterar a través de todos los elementos en "CompletedTasks"
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let taskData = childSnapshot.value as? [String: Any],
                   let date = taskData["date"] as? String,
                   let typeTaskString = taskData["typeTask"] as? String,
                   let typeTask = TaskType(rawValue: typeTaskString),
                   typeTask == self.typeTask && date == formattedDate {
                    // Se ha encontrado un duplicado
                    duplicateFound = true
                }
            }
            
            if duplicateFound {
                if self.typeTask == .diet {
                    NotificationCenter.default.post(name: Notification.Name("DietDuplicateTaskDetected"), object: nil)
                } else {
                    NotificationCenter.default.post(name: Notification.Name("WorkoutDuplicateTaskDetected"), object: nil)
                }
            } else {
                // No se encontró ningún duplicado, subir el nuevo objeto a Firebase Database
                let completedTasksRef = databaseRef.child("CompletedTasks").childByAutoId()
                
                // Subir el diccionario a Firebase Database
                completedTasksRef.setValue(taskDictionary) { (error, _) in
                    if let error = error {
                        print("Error al subir los datos: \(error.localizedDescription)")
                    } else {
                        print("Datos subidos exitosamente")
                    }
                }
                
                if self.typeTask == .diet {
                    NotificationCenter.default.post(name: Notification.Name("DietTaskCompletedSuccessfully"), object: nil)
                } else {
                    NotificationCenter.default.post(name: Notification.Name("WorkoutTaskCompletedSuccessfully"), object: nil)
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension PopupViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == placeholderText && (textView.selectedRange.location == 0 || textView.selectedRange.location == NSNotFound) {
            // Si el texto es igual al placeholder y el cursor está al inicio o al final
            textView.textColor = placeholderColor
        } else {
            textView.textColor = .black // Restaurar color de texto normal
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = placeholderColor
        }
    }
}
