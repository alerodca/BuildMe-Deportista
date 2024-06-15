//
//  ExerciseDetailViewController.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 29/5/24.
//

import UIKit

class ExerciseDetailViewController: UIViewController {

    // MARK: - IBOUtlets
    @IBOutlet var backView: UIView!
    @IBOutlet var exerciseNameLabel: UILabel!
    @IBOutlet var exerciseImageView: UIImageView!
    @IBOutlet var descriptionExerciseTextView: UITextView!
    @IBOutlet var muscleLabel: UILabel!
    @IBOutlet var setsLabel: UILabel!
    @IBOutlet var repsLabel: UILabel!
    
    // MARK: - Variables
    let exercise: Exercise
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfigure()
    }
    
    // MARK: - Constructor
    init(exercise: Exercise) {
        self.exercise = exercise
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions & Selectors
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Functions
    
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
        
        exerciseNameLabel.text = exercise.name
        exerciseImageView.loadImage(from: exercise.image)
        descriptionExerciseTextView.font = UIFont.boldSystemFont(ofSize: 16)
        descriptionExerciseTextView.text = exercise.description
        muscleLabel.text = "Músculo trabajado: \(exercise.muscleGroup.rawValue)"
        setsLabel.text = "Series: \(exercise.sets)"
        repsLabel.text = "Repeticiones: \(exercise.reps)"
    }
}
