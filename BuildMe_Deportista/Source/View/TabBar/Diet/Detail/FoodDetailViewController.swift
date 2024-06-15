//
//  FoodDetailViewController.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 29/5/24.
//

import UIKit

class FoodDetailViewController: UIViewController {

    // MARK: - IBOUtlets
    @IBOutlet var backView: UIView!
    @IBOutlet var recipeNameLabel: UILabel!
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var recipeDataTextView: UITextView!
    
    // MARK: - Variables
    let recipe: Recipe
    
    // MARK: - Constructor
    init(recipe: Recipe) {
        self.recipe = recipe
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
        
        recipeNameLabel.text = recipe.name
        recipeImageView.loadImage(from: recipe.image)
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .paragraphStyle: NSMutableParagraphStyle().centered()
        ]
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 15)
        ]
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15)
        ]
        
        let titleString = NSAttributedString(string: "Detalles\n", attributes: titleAttributes)
        let attributedString = NSMutableAttributedString()
        attributedString.append(titleString)
        attributedString.append(NSAttributedString(string: "Ingredientes: ", attributes: boldAttributes))
        attributedString.append(NSAttributedString(string: "\(recipe.ingredients.joined(separator: ", ")).\n\n", attributes: normalAttributes))
        attributedString.append(NSAttributedString(string: "Tipo Comida: ", attributes: boldAttributes))
        attributedString.append(NSAttributedString(string: "\(recipe.mealType.rawValue).\n\n", attributes: normalAttributes))
        attributedString.append(NSAttributedString(string: "Tiempo Preparación: ", attributes: boldAttributes))
        attributedString.append(NSAttributedString(string: "\(recipe.preparationTime)min.\n\n", attributes: normalAttributes))
        attributedString.append(NSAttributedString(string: "Raciones: ", attributes: boldAttributes))
        attributedString.append(NSAttributedString(string: "\(recipe.servings).\n\n", attributes: normalAttributes))
        
        if let tips = recipe.tips {
            attributedString.append(NSAttributedString(string: "Tips: ", attributes: boldAttributes))
            attributedString.append(NSAttributedString(string: "\(String.removeOptional(from: recipe.tips ?? "No hay tips.")).\n\n", attributes: normalAttributes))
        }
        
        attributedString.append(NSAttributedString(string: "Valores Nutricionales: ", attributes: boldAttributes))
        attributedString.append(NSAttributedString(string: "Calorías: ", attributes: boldAttributes))
        attributedString.append(NSAttributedString(string: "\(recipe.nutritionalValues.calories)kcal, ", attributes: normalAttributes))
        attributedString.append(NSAttributedString(string: "Proteínas: ", attributes: boldAttributes))
        attributedString.append(NSAttributedString(string: "\(recipe.nutritionalValues.protein)g, ", attributes: normalAttributes))
        attributedString.append(NSAttributedString(string: "Grasas: ", attributes: boldAttributes))
        attributedString.append(NSAttributedString(string: "\(recipe.nutritionalValues.fat)g, ", attributes: normalAttributes))
        attributedString.append(NSAttributedString(string: "Carbohidratos: ", attributes: boldAttributes))
        attributedString.append(NSAttributedString(string: "\(recipe.nutritionalValues.carbohydrates)g.", attributes: normalAttributes))
        
        recipeDataTextView.attributedText = attributedString
        recipeDataTextView.isEditable = false
        recipeDataTextView.isScrollEnabled = true
    }
}
