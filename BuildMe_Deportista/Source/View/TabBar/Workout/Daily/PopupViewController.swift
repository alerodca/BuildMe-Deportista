//
//  PopupViewController.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 30/5/24.
//

import UIKit

class PopupViewController: UIViewController {
    // MARK: - Properties
    private let textField = UITextField()
    private let datePicker = UIDatePicker()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Escribe aquí..."
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5.0
        popupView.addSubview(textField)
        
        // Añadir padding al UITextField
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
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
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cancelButton.layer.cornerRadius = 10 // Agregar borde al botón
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        popupView.addSubview(cancelButton)
        
        // Botón azul (Guardar)
        let saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Guardar", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .blue
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        saveButton.layer.cornerRadius = 10 // Agregar borde al botón
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        popupView.addSubview(saveButton)
        
        // Agregar constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -16),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 80),
            
            datePicker.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
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
    
    // MARK: - Button Actions
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        let enteredText = textField.text ?? ""
        let selectedDate = datePicker.date
        print("Texto: \(enteredText)")
        print("Fecha seleccionada: \(selectedDate)")
        dismiss(animated: true, completion: nil)
    }
}
