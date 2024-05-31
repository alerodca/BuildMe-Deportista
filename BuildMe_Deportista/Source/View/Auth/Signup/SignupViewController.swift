//
//  SignupViewController.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 11/5/24.
//

import UIKit

class SignupViewController: UIViewController {
    
    // MARK: - Variables
    let nameTextField = UITextField()
    let emailTextField = UITextField()
    let phoneTextField = UITextField()
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    let injuryHistoryTextField = UITextField()
    let clinicHistoryTextField = UITextField()
    let prefTrainingPickerView = UIPickerView()
    let availableTimePickerView = UIPickerView()
    let geographicAvailabilityPickerView = UIPickerView()
    let physicConditionPickerView = UIPickerView()
    let buttonAlreadyHaveAccount = UIButton(type: .system)
    let createAccountButton = UIButton(type: .system)
    let uploadPhotoButton = UIButton(type: .system)
    
    let viewmodel = SignupViewModel()
    let imageIcon = UIImageView()
    var iconClick = false
    
    // MARK: - Enums
    enum TrainingGoal: String, CaseIterable {
        case loseWeight = "Perder peso"
        case gainMuscleMass = "Ganar masa muscular"
        case stayInShape = "Mantenerse en forma"
        case improveEndurance = "Mejorar resistencia"
    }
    
    enum Schedule: String, CaseIterable {
        case morning = "Mañana"
        case afternoon = "Tarde"
        case evening = "Noche"
    }
    
    enum TrainingOptions: String, CaseIterable {
        case atHome = "En casa"
        case atGym = "En gimnasio"
        case alternate = "Alterno"
    }
    
    enum PhysicalCondition: String, CaseIterable {
        case poor = "Baja condición física"
        case average = "Condición física promedio"
        case good = "Buena condición física"
        case excellent = "Excelente condición física"
    }
    
    enum Gender: String {
        case male = "Masculino"
        case female = "Femenino"
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func buttonAlreadyHaveAccountAction() {
        viewmodel.popToLogin()
    }
    @objc func maleButtonTapped() {
        viewmodel.setGender(gender: Gender.male.rawValue)
    }
    
    @objc func femaleButtonTapped() {
        viewmodel.setGender(gender: Gender.female.rawValue)
    }
    
    @objc func datePickerDidChange(_ datePicker: UIDatePicker) {
        viewmodel.setDateBirth(selectedDate: datePicker.date)
    }
    
    @objc func uploadPhotoButtonTapped() {
        viewmodel.selectImage()
    }
    
    @objc func createAccountButtonTapped() {
        viewmodel.createAccount()
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        if iconClick {
            iconClick = false
            tappedImage.image = UIImage(named: "eyeOpen")
            passwordTextField.isSecureTextEntry = false
        } else {
            iconClick = true
            tappedImage.image = UIImage(named: "eyeClose")
            passwordTextField.isSecureTextEntry = true
        }
    }
    // MARK: - Private Functions
    private func configureUI() {
        view.applyBlueRedGradient()
        
        // BuildMe Logo
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "LogoTransparente")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        // CardView
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 20
        cardView.clipsToBounds = true
        view.addSubview(cardView)
        
        // Label inside StackView
        let labelAlreadyHaveAccount = UILabel()
        labelAlreadyHaveAccount.text = "¿Ya tienes cuenta?"
        labelAlreadyHaveAccount.textAlignment = .center
        labelAlreadyHaveAccount.translatesAutoresizingMaskIntoConstraints = false
        labelAlreadyHaveAccount.font = UIFont.boldSystemFont(ofSize: 18)
        labelAlreadyHaveAccount.textColor = .white
        
        // Button inside StackView
        buttonAlreadyHaveAccount.setTitle("Iniciar Sesión", for: .normal)
        buttonAlreadyHaveAccount.translatesAutoresizingMaskIntoConstraints = false
        buttonAlreadyHaveAccount.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        buttonAlreadyHaveAccount.tintColor = .white
        
        // StackView
        let bottomStackView = UIStackView(arrangedSubviews: [labelAlreadyHaveAccount, buttonAlreadyHaveAccount])
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fillEqually
        bottomStackView.spacing = 10
        view.addSubview(bottomStackView)
        
        // ScrollView
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(scrollView)
        
        // ContentView
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        cardView.clipsToBounds = true
        scrollView.addSubview(contentView)
        
        // personalDataLabel
        let personalDataLabel = UILabel()
        personalDataLabel.text = "Datos Personales"
        personalDataLabel.textAlignment = .center
        personalDataLabel.font = UIFont.boldSystemFont(ofSize: 27)
        personalDataLabel.translatesAutoresizingMaskIntoConstraints = false
        personalDataLabel.textColor = .black
        contentView.addSubview(personalDataLabel)
        
        // nameTextField
        nameTextField.placeholder = "Nombre y Apellidos"
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.delegate = self
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.cornerRadius = 8.0
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameTextField.frame.height))
        nameTextField.leftViewMode = .always
        contentView.addSubview(nameTextField)
        
        // Gender Label
        let genderLabel = UILabel()
        genderLabel.text = "Género"
        genderLabel.font = UIFont.boldSystemFont(ofSize: 17)
        genderLabel.textAlignment = .center
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Male Button
        let maleButton = UIButton(type: .system)
        maleButton.setTitle("Masculino", for: .normal)
        maleButton.tintColor = .white
        maleButton.backgroundColor = .blue
        maleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        maleButton.translatesAutoresizingMaskIntoConstraints = false
        maleButton.layer.cornerRadius = 5
        
        // Female Button
        let femaleButton = UIButton(type: .system)
        femaleButton.setTitle("Femenino", for: .normal)
        femaleButton.tintColor = .white
        femaleButton.backgroundColor = .systemPink
        femaleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        femaleButton.translatesAutoresizingMaskIntoConstraints = false
        femaleButton.layer.cornerRadius = 5
        
        // Gender StackView
        let genderStackView = UIStackView()
        genderStackView.axis = .horizontal
        genderStackView.spacing = 10
        genderStackView.translatesAutoresizingMaskIntoConstraints = false
        genderStackView.distribution = .fillEqually
        genderStackView.addArrangedSubview(genderLabel)
        genderStackView.addArrangedSubview(maleButton)
        genderStackView.addArrangedSubview(femaleButton)
        contentView.addSubview(genderStackView)
        
        // Datebirth Label
        let datebirthLabel = UILabel()
        datebirthLabel.text = "Fecha de Nacimiento"
        datebirthLabel.font = UIFont.boldSystemFont(ofSize: 17)
        datebirthLabel.textAlignment = .center
        datebirthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // DatePicker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Datebirth StackView
        let dateBirthStackView = UIStackView()
        dateBirthStackView.axis = .horizontal
        dateBirthStackView.spacing = 10
        dateBirthStackView.translatesAutoresizingMaskIntoConstraints = false
        dateBirthStackView.distribution = .fillProportionally
        dateBirthStackView.addArrangedSubview(datebirthLabel)
        dateBirthStackView.addArrangedSubview(datePicker)
        contentView.addSubview(dateBirthStackView)
        
        // emailTextField
        emailTextField.placeholder = "Email"
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.delegate = self
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.cornerRadius = 8.0
        emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameTextField.frame.height))
        emailTextField.leftViewMode = .always
        contentView.addSubview(emailTextField)
        
        // phoneTextField
        phoneTextField.placeholder = "Número de Teléfono"
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.delegate = self
        phoneTextField.keyboardType = .numberPad
        phoneTextField.layer.borderColor = UIColor.lightGray.cgColor
        phoneTextField.layer.borderWidth = 1.0
        phoneTextField.layer.cornerRadius = 8.0
        phoneTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameTextField.frame.height))
        phoneTextField.leftViewMode = .always
        phoneTextField.keyboardType = .numberPad
        contentView.addSubview(phoneTextField)
        
        // usernameTextField
        usernameTextField.placeholder = "Usuario"
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.delegate = self
        usernameTextField.layer.borderColor = UIColor.lightGray.cgColor
        usernameTextField.layer.borderWidth = 1.0
        usernameTextField.layer.cornerRadius = 8.0
        usernameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameTextField.frame.height))
        usernameTextField.leftViewMode = .always
        contentView.addSubview(usernameTextField)
        
        // passwordTextField
        imageIcon.image = UIImage(named: "eyeClose")
        let subContentView = UIView()
        subContentView.addSubview(imageIcon)
        subContentView.frame = CGRect(x: 0, y: 0, width: UIImage(named: "eyeClose")!.size.width, height: UIImage(named: "eyeClose")!.size.height)
        imageIcon.frame = CGRect(x: -10, y: 0, width: UIImage(named: "eyeClose")!.size.width, height: UIImage(named: "eyeClose")!.size.height)
        passwordTextField.rightView = subContentView
        passwordTextField.rightViewMode = .always
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageIcon.isUserInteractionEnabled = true
        imageIcon.addGestureRecognizer(tapGestureRecognizer)
        
        passwordTextField.placeholder = "Contraseña"
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.delegate = self
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.cornerRadius = 8.0
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameTextField.frame.height))
        passwordTextField.leftViewMode = .always
        passwordTextField.isSecureTextEntry = true
        contentView.addSubview(passwordTextField)
        
        // physicDataLabel
        let physicDataLabel = UILabel()
        physicDataLabel.text = "Datos Adicionales"
        physicDataLabel.textAlignment = .center
        physicDataLabel.font = UIFont.boldSystemFont(ofSize: 27)
        physicDataLabel.translatesAutoresizingMaskIntoConstraints = false
        physicDataLabel.textColor = .black
        contentView.addSubview(physicDataLabel)
        
        // prefTrainingStackView
        let prefTrainingStackView = UIStackView()
        prefTrainingStackView.axis = .vertical
        prefTrainingStackView.spacing = 10
        prefTrainingStackView.translatesAutoresizingMaskIntoConstraints = false
        prefTrainingStackView.distribution = .fillEqually
        contentView.addSubview(prefTrainingStackView)
        
        // prefTrainingLabel
        let prefTrainingLabel = UILabel()
        prefTrainingLabel.text = "Objetivos a buscar"
        prefTrainingLabel.font = UIFont.boldSystemFont(ofSize: 18)
        prefTrainingLabel.textAlignment = .center
        prefTrainingLabel.translatesAutoresizingMaskIntoConstraints = false
        prefTrainingStackView.addArrangedSubview(prefTrainingLabel)
        
        // prefTrainingPickerView
        prefTrainingPickerView.dataSource = self
        prefTrainingPickerView.delegate = self
        prefTrainingPickerView.translatesAutoresizingMaskIntoConstraints = false
        prefTrainingStackView.addArrangedSubview(prefTrainingPickerView)
        
        // availableTimeStackView
        let availableTimeStackView = UIStackView()
        availableTimeStackView.axis = .vertical
        availableTimeStackView.spacing = 10
        availableTimeStackView.translatesAutoresizingMaskIntoConstraints = false
        availableTimeStackView.distribution = .fillEqually
        contentView.addSubview(availableTimeStackView)
        
        // availableTimeLabel
        let availableTimeLabel = UILabel()
        availableTimeLabel.text = "Disponibilidad horaria"
        availableTimeLabel.font = UIFont.boldSystemFont(ofSize: 18)
        availableTimeLabel.textAlignment = .center
        availableTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        availableTimeStackView.addArrangedSubview(availableTimeLabel)
        
        // availableTimePickerView
        availableTimePickerView.dataSource = self
        availableTimePickerView.delegate = self
        availableTimePickerView.translatesAutoresizingMaskIntoConstraints = false
        availableTimeStackView.addArrangedSubview(availableTimePickerView)
        
        // geographicAvailabilityStackView
        let geographicAvailabilityStackView = UIStackView()
        geographicAvailabilityStackView.axis = .vertical
        geographicAvailabilityStackView.translatesAutoresizingMaskIntoConstraints = false
        geographicAvailabilityStackView.distribution = .fillEqually
        contentView.addSubview(geographicAvailabilityStackView)
        
        // geographicAvailabilityLabel
        let geographicAvailabilityLabel = UILabel()
        geographicAvailabilityLabel.text = "Preferencia Física"
        geographicAvailabilityLabel.font = UIFont.boldSystemFont(ofSize: 18)
        geographicAvailabilityLabel.textAlignment = .center
        geographicAvailabilityLabel.translatesAutoresizingMaskIntoConstraints = false
        geographicAvailabilityStackView.addArrangedSubview(geographicAvailabilityLabel)
        
        // geographicAvailabilityPickerView
        geographicAvailabilityPickerView.dataSource = self
        geographicAvailabilityPickerView.delegate = self
        geographicAvailabilityPickerView.translatesAutoresizingMaskIntoConstraints = false
        geographicAvailabilityStackView.addArrangedSubview(geographicAvailabilityPickerView)
        
        // clinicHistoryTextField
        clinicHistoryTextField.placeholder = "Historial médico"
        clinicHistoryTextField.translatesAutoresizingMaskIntoConstraints = false
        clinicHistoryTextField.delegate = self
        clinicHistoryTextField.layer.borderColor = UIColor.lightGray.cgColor
        clinicHistoryTextField.layer.borderWidth = 1.0
        clinicHistoryTextField.layer.cornerRadius = 8.0
        clinicHistoryTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameTextField.frame.height))
        clinicHistoryTextField.leftViewMode = .always
        contentView.addSubview(clinicHistoryTextField)
        
        // injuryHistoryTextField
        injuryHistoryTextField.placeholder = "Historial lesiones"
        injuryHistoryTextField.translatesAutoresizingMaskIntoConstraints = false
        injuryHistoryTextField.delegate = self
        injuryHistoryTextField.layer.borderColor = UIColor.lightGray.cgColor
        injuryHistoryTextField.layer.borderWidth = 1.0
        injuryHistoryTextField.layer.cornerRadius = 8.0
        injuryHistoryTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameTextField.frame.height))
        injuryHistoryTextField.leftViewMode = .always
        contentView.addSubview(injuryHistoryTextField)
        
        // physicConditionStackView
        let physicConditionStackView = UIStackView()
        physicConditionStackView.axis = .vertical
        physicConditionStackView.translatesAutoresizingMaskIntoConstraints = false
        physicConditionStackView.distribution = .fillEqually
        contentView.addSubview(physicConditionStackView)
        
        // physicConditionLabel
        let physicConditionLabel = UILabel()
        physicConditionLabel.text = "Condición Física"
        physicConditionLabel.font = UIFont.boldSystemFont(ofSize: 18)
        physicConditionLabel.textAlignment = .center
        physicConditionLabel.translatesAutoresizingMaskIntoConstraints = false
        physicConditionStackView.addArrangedSubview(physicConditionLabel)
        
        // physicConditionPickerView
        physicConditionPickerView.dataSource = self
        physicConditionPickerView.delegate = self
        physicConditionPickerView.translatesAutoresizingMaskIntoConstraints = false
        physicConditionStackView.addArrangedSubview(physicConditionPickerView)
        
        // uploadPhotoButton
        let iconImage = UIImage(systemName: "camera")
        uploadPhotoButton.setImage(iconImage, for: .normal)
        uploadPhotoButton.tintColor = .white
        uploadPhotoButton.setTitle("Foto de Perfil", for: .normal)
        uploadPhotoButton.setTitleColor(.white, for: .normal)
        uploadPhotoButton.backgroundColor = .systemGray
        uploadPhotoButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        uploadPhotoButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        uploadPhotoButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        uploadPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        uploadPhotoButton.layer.cornerRadius = 5
        contentView.addSubview(uploadPhotoButton)
        
        // createAccountButton
    
        createAccountButton.tintColor = .white
        createAccountButton.setTitle("Crear Cuenta", for: .normal)
        createAccountButton.setTitleColor(.white, for: .normal)
        createAccountButton.backgroundColor = .systemBlue
        createAccountButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        createAccountButton.layer.cornerRadius = 5
        view.addSubview(createAccountButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            // Constraints Logo BuildMe
            logoImageView.widthAnchor.constraint(equalToConstant: 175),
            logoImageView.heightAnchor.constraint(equalToConstant: 175),
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // Constraints CardView
            cardView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: createAccountButton.topAnchor, constant: -16),
            // Constraints StackView
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
            bottomStackView.heightAnchor.constraint(equalToConstant: 50),
            // Constraints scrollView
            scrollView.topAnchor.constraint(equalTo: cardView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            // Constraints ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 2.6),
            // Constraints personalDataLabel
            personalDataLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
            personalDataLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            personalDataLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            personalDataLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            personalDataLabel.heightAnchor.constraint(equalToConstant: 50),
            // Constraints nameTextField
            nameTextField.topAnchor.constraint(equalTo: personalDataLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            nameTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            // Constraints genderStackView
            genderStackView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            genderStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            genderStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            genderStackView.heightAnchor.constraint(equalToConstant: 50),
            // Constraints dateBirthStackView
            dateBirthStackView.topAnchor.constraint(equalTo: genderStackView.bottomAnchor, constant: 8),
            dateBirthStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            dateBirthStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            dateBirthStackView.heightAnchor.constraint(equalToConstant: 50),
            // Constraints emailTextField
            emailTextField.topAnchor.constraint(equalTo: dateBirthStackView.bottomAnchor, constant: 8),
            emailTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            emailTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            // Constraints phoneTextField
            phoneTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8),
            phoneTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            phoneTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            phoneTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            phoneTextField.heightAnchor.constraint(equalToConstant: 50),
            // Constraints usernameTextField
            usernameTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 8),
            usernameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            usernameTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            usernameTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            // Constraints passwordTextField
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            passwordTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            // Constraints physicDataLabel
            physicDataLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            physicDataLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            physicDataLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            physicDataLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            physicDataLabel.heightAnchor.constraint(equalToConstant: 50),
            // Constraints prefTrainingStackView
            prefTrainingStackView.topAnchor.constraint(equalTo: physicDataLabel.bottomAnchor, constant: 8),
            prefTrainingStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            prefTrainingStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            prefTrainingStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            prefTrainingStackView.heightAnchor.constraint(equalToConstant: 100),
            // Constraints availableTimeStackView
            availableTimeStackView.topAnchor.constraint(equalTo: prefTrainingStackView.bottomAnchor, constant: 8),
            availableTimeStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            availableTimeStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            availableTimeStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            availableTimeStackView.heightAnchor.constraint(equalToConstant: 100),
            // Constraints geographicAvailabilityStackView
            geographicAvailabilityStackView.topAnchor.constraint(equalTo: availableTimeStackView.bottomAnchor, constant: 8),
            geographicAvailabilityStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            geographicAvailabilityStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            geographicAvailabilityStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            geographicAvailabilityStackView.heightAnchor.constraint(equalToConstant: 100),
            // Constraints clinicHistoryTextField
            clinicHistoryTextField.topAnchor.constraint(equalTo: geographicAvailabilityStackView.bottomAnchor, constant: 8),
            clinicHistoryTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            clinicHistoryTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            clinicHistoryTextField.heightAnchor.constraint(equalToConstant: 50),
            // Constraints injuryHistoryTextField
            injuryHistoryTextField.topAnchor.constraint(equalTo: clinicHistoryTextField.bottomAnchor, constant: 8),
            injuryHistoryTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            injuryHistoryTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            injuryHistoryTextField.heightAnchor.constraint(equalToConstant: 50),
            // Constraints physicConditionStackView
            physicConditionStackView.topAnchor.constraint(equalTo: injuryHistoryTextField.bottomAnchor, constant: 8),
            physicConditionStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            physicConditionStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            physicConditionStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            physicConditionStackView.heightAnchor.constraint(equalToConstant: 100),
            // Constraints uploadPhotoButton
            uploadPhotoButton.topAnchor.constraint(equalTo: physicConditionStackView.bottomAnchor, constant: 8),
            uploadPhotoButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 48),
            uploadPhotoButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -48),
            uploadPhotoButton.heightAnchor.constraint(equalToConstant: 50),
            // Constraints createAccountButton
            createAccountButton.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -16),
            createAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64),
            createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -64),
            createAccountButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        buttonAlreadyHaveAccount.addTarget(self, action: #selector(buttonAlreadyHaveAccountAction), for: .touchUpInside)
        maleButton.addTarget(self, action: #selector(maleButtonTapped), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(femaleButtonTapped), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(datePickerDidChange(_:)), for: .valueChanged)
        uploadPhotoButton.addTarget(self, action: #selector(uploadPhotoButtonTapped), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        
        self.navigationItem.hidesBackButton = true
        viewmodel.delegate = self
        viewmodel.pickerDelegate = self
    }
    
}

// MARK: - Extension UIPickerViewDelegate
extension SignupViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title: String
        switch pickerView {
        case prefTrainingPickerView:
            title = TrainingGoal.allCases[row].rawValue
        case availableTimePickerView:
            title = Schedule.allCases[row].rawValue
        case geographicAvailabilityPickerView:
            title = TrainingOptions.allCases[row].rawValue
        case physicConditionPickerView:
            title = PhysicalCondition.allCases[row].rawValue
        default:
            title = ""
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 13)
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case prefTrainingPickerView:
            viewmodel.setTrainingGoal(text: TrainingGoal.allCases[row].rawValue)
        case availableTimePickerView:
            viewmodel.setSchedule(text: Schedule.allCases[row].rawValue)
        case geographicAvailabilityPickerView:
            viewmodel.setGeographicAvailable(text: TrainingOptions.allCases[row].rawValue)
        case physicConditionPickerView:
            viewmodel.setPhysicCondition(text: PhysicalCondition.allCases[row].rawValue)
        default:
            break
        }
    }
}

// MARK: - Extension UIPickerViewDataSource
extension SignupViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case prefTrainingPickerView:
            return TrainingGoal.allCases.count
        case availableTimePickerView:
            return Schedule.allCases.count
        case geographicAvailabilityPickerView:
            return TrainingOptions.allCases.count
        case physicConditionPickerView:
            return PhysicalCondition.allCases.count
        default:
            return 0
        }
    }
}

// MARK: - Extension UITextViewDelegate
extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            viewmodel.setName(text: nameTextField.text)
        case emailTextField:
            viewmodel.setEmail(text: emailTextField.text)
        case phoneTextField:
            viewmodel.setPhone(text: phoneTextField.text)
        case usernameTextField:
            viewmodel.setUsername(text: usernameTextField.text)
        case passwordTextField:
            viewmodel.setPassword(text: passwordTextField.text)
        case clinicHistoryTextField:
            viewmodel.setClinicHistory(text: clinicHistoryTextField.text)
        case injuryHistoryTextField:
            viewmodel.setinjuryHistory(text: injuryHistoryTextField.text)
        default:
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension SignupViewController: AuthControllerDelegate, ImagePickerDelegate {
    func enableButtons() {
        uploadPhotoButton.isEnabled = true
        buttonAlreadyHaveAccount.isEnabled = true
    }
    
    func disableButtons() {
        uploadPhotoButton.isEnabled = false
        buttonAlreadyHaveAccount.isEnabled = false
    }
    
    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func authComplete() {
        dismiss(animated: true)
    }
    
    func navigate() {
        navigationController?.popViewController(animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            viewmodel.saveImage(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.showAlert(title: "Imagen", message: "Ninguna imagen seleccionada.")
        }
    }
}

