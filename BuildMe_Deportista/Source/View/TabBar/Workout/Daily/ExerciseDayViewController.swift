//
//  ExerciseDayViewController.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 29/5/24.
//

import UIKit

class ExerciseDayViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var muscleGroupLabel: UILabel!
    @IBOutlet var exerciseDayLabel: UILabel!
    @IBOutlet var backView: UIView!
    @IBOutlet var completedDayButton: UIButton!
    
    // MARK: - Variables
    let exerciseDay: ExerciseDay
    
    // MARK: - Constructor
    init(exerciseDay: ExerciseDay) {
        self.exerciseDay = exerciseDay
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfigure()
    }
    
    // MARK: - Actions & Selectors
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completedDayAction(_ sender: UIButton) {
        completedDayAlert(on: self)
    }
    
    // MARK: - Private Functions
    private func initialConfigure() {
        view.applyBlueRedGradient()
        
        let backImage = UIImage(systemName: "arrow.backward")
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(dismissSelf))
        backButton.tintColor = .white
        backButton.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white],
            for: .normal)
        navigationItem.leftBarButtonItem = backButton
        
        backView.layer.cornerRadius = 15
        backView.layer.masksToBounds = true
        
        exerciseDayLabel.text = "Día Correspondiente: \(exerciseDay.day.rawValue)"
        muscleGroupLabel.text = "Músculos a trabajar: \(exerciseDay.muscleGroup.map { $0.rawValue }.joined(separator: ", "))"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PrincipalTableViewCell", bundle: nil), forCellReuseIdentifier: "PrincipalTableViewCell")
        
        completedDayButton.layer.cornerRadius = 10
        completedDayButton.layer.masksToBounds = true
    }
    
    private func completedDayAlert(on viewController: UIViewController) {
        // Instanciar el PopupViewController
        let popupVC = PopupViewController()
        
        // Configurar el estilo de presentación del popup
        popupVC.modalPresentationStyle = .overFullScreen // Para que el fondo se mantenga semitransparente
        
        // Presentar el popup
        present(popupVC, animated: true, completion: nil)
    }
    
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ExerciseDayViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseDay.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PrincipalTableViewCell", for: indexPath) as? PrincipalTableViewCell else { return UITableViewCell() }
        
        let exercise = exerciseDay.exercises[indexPath.row]
        
        let nameAttributedString = NSMutableAttributedString(string: "Nombre: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13)])
        nameAttributedString.append(NSAttributedString(string: exercise.name))
        cell.titleOneLabel.attributedText = nameAttributedString
        
        let setsAttributedString = NSMutableAttributedString(string: "Series: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13)])
        setsAttributedString.append(NSAttributedString(string: String(exercise.sets)))
        cell.titleSecondLabel.attributedText = setsAttributedString
        
        let repsAttributedString = NSMutableAttributedString(string: "Reps: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13)])
        repsAttributedString.append(NSAttributedString(string: String(exercise.reps)))
        cell.titleThirdLabel.attributedText = repsAttributedString
        
        cell.imageViewCell.loadImage(from: exercise.image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedExercise = exerciseDay.exercises[indexPath.row]
        let vc = ExerciseDetailViewController(exercise: selectedExercise)
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}
