//
//  PopupViewController.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 30/5/24.
//

import UIKit
import JGProgressHUD

class PopupViewController: UIViewController {
    
    // MARK: - Properties
    private let textView = UITextView()
    private let datePicker = UIDatePicker()
    private let placeholderText = "Si tienes alguna observación puedes ponerla aquí..."
    let placeholderColor = UIColor.lightGray
    
    private var viewModel: PopupViewModel
    
    // MARK: - Constructor
    init(typeTask: TaskType) {
        self.viewModel = PopupViewModel(typeTask: typeTask)
        super.init(nibName: nil, bundle: nil)
    }
    
    init(completedTask: TaskCompleted?) {
        self.viewModel = PopupViewModel(completedTask: completedTask)
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
        bindViewModel()
        
        if let completedTask = viewModel.completedTask {
            textView.text = completedTask.observations
            textView.textColor = .black
            datePicker.date = completedTask.date
        } else {
            textView.text = placeholderText
            textView.textColor = placeholderColor
        }
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let popupView = UIView()
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.backgroundColor = .white
        popupView.layer.cornerRadius = 10
        view.addSubview(popupView)
        
        NSLayoutConstraint.activate([
            popupView.widthAnchor.constraint(equalToConstant: 300),
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "¡Guardar como completado!"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.textAlignment = .center
        popupView.addSubview(titleLabel)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .justified
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5.0
        popupView.addSubview(textView)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .compact
        }
        popupView.addSubview(datePicker)
        
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancelar", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = .red
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        cancelButton.layer.cornerRadius = 10
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        popupView.addSubview(cancelButton)
        
        let saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Guardar", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .blue
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        popupView.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -16),
            
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -16),
            textView.heightAnchor.constraint(equalToConstant: 80),
            
            datePicker.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            datePicker.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            
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
    }
    
    private func bindViewModel() {
        viewModel.onTaskSaved = { [weak self] in
            DispatchQueue.main.async {
                self?.dismiss(animated: true, completion: nil)
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Actions
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        viewModel.observations = textView.text
        viewModel.selectedDate = datePicker.date
        viewModel.saveTask()
    }
}

extension PopupViewController: UITextViewDelegate {
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
