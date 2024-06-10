//
//  DietDayViewController.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 29/5/24.
//

import UIKit
import JGProgressHUD

class DietDayViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dietDayLabel: UILabel!
    @IBOutlet var backView: UIView!
    @IBOutlet var nutritionalValuesLabel: UILabel!
    @IBOutlet var completedDayButton: UIButton!
    
    // MARK: - Variables
    let dietDay: DietDay
    
    // MARK: - Constructor
    init(dietDay: DietDay) {
        self.dietDay = dietDay
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfigure()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTaskCompletedNotification), name: Notification.Name("DietTaskCompletedSuccessfully"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDuplicateTaskNotification), name: Notification.Name("DietDuplicateTaskDetected"), object: nil)

    }
    
    // MARK: - Actions & Selectors
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completedDayButtonAction(_ sender: UIButton) {
        completedDayAlert(on: self)
    }
    
    @objc private func handleDuplicateTaskNotification() {
        showAlert(title: "Error", message: "Ya existe un objeto con la misma fecha y tipo de tarea", isError: true)
    }
    
    @objc private func handleTaskCompletedNotification() {
        showAlert(title: "Éxito", message: "Datos subidos exitosamente", isError: false)
    }
    
    @objc private func showTaskCompleted() {
        let vc = InfoTaskViewController()
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
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
        
        let infoTaskImage = UIImage(systemName: "checkmark.circle")
        let infoTaskButton = UIBarButtonItem(image: infoTaskImage, style: .plain, target: self, action: #selector(showTaskCompleted))
        infoTaskButton.tintColor = .white
        infoTaskButton.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white],
            for: .normal)
        navigationItem.rightBarButtonItem = infoTaskButton
        
        backView.layer.cornerRadius = 15
        backView.layer.masksToBounds = true
        
        dietDayLabel.text = "Día de Dieta: \(dietDay.day.rawValue)"
        nutritionalValuesLabel.attributedText = formatNutritionalValues(dietDay.nutritionalGoals)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PrincipalTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        completedDayButton.layer.cornerRadius = 10
        completedDayButton.layer.masksToBounds = true
    }
    
    private func formatNutritionalValues(_ values: NutritionalValues) -> NSAttributedString {
        let boldFont = UIFont.boldSystemFont(ofSize: 14)
        let normalFont = UIFont.systemFont(ofSize: 14)
        
        let boldAttributes: [NSAttributedString.Key: Any] = [.font: boldFont]
        let normalAttributes: [NSAttributedString.Key: Any] = [.font: normalFont]
        
        let formattedString = NSMutableAttributedString()
        
        formattedString.append(NSAttributedString(string: "Valores Nutricionales\n", attributes: boldAttributes))
        
        formattedString.append(NSAttributedString(string: "Calorías: ", attributes: boldAttributes))
        formattedString.append(NSAttributedString(string: "\(values.calories)kcal\n", attributes: normalAttributes))
        
        formattedString.append(NSAttributedString(string: "Proteínas: ", attributes: boldAttributes))
        formattedString.append(NSAttributedString(string: "\(values.protein)g\n", attributes: normalAttributes))
        
        formattedString.append(NSAttributedString(string: "Carbohidratos: ", attributes: boldAttributes))
        formattedString.append(NSAttributedString(string: "\(values.carbohydrates)g\n", attributes: normalAttributes))
        
        formattedString.append(NSAttributedString(string: "Grasas: ", attributes: boldAttributes))
        formattedString.append(NSAttributedString(string: "\(values.fat)g", attributes: normalAttributes))
        
        return formattedString
    }
    
    private func completedDayAlert(on viewController: UIViewController) {
        // Instanciar el PopupViewController
        let popupVC = PopupViewController(typeTask: .diet)
        
        // Configurar el estilo de presentación del popup
        popupVC.modalPresentationStyle = .overFullScreen // Para que el fondo se mantenga semitransparente
        
        // Presentar el popup
        present(popupVC, animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String, isError: Bool) {
        DispatchQueue.main.async {
            let hud = JGProgressHUD(style: .dark)
            
            // Configurar el estilo del indicador según si es un error o no
            hud.indicatorView = isError ? JGProgressHUDErrorIndicatorView() : JGProgressHUDSuccessIndicatorView()
            
            hud.textLabel.text = title
            hud.detailTextLabel.text = message
            
            // Bloquear todas las interacciones hasta que se cierre el alert
            hud.interactionType = .blockAllTouches
            
            // Mostrar el alert en la vista actual
            hud.show(in: self.view)
            
            // Desaparecer después de un tiempo determinado
            hud.dismiss(afterDelay: 3, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DietDayViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 // Breakfast, Lunch, Snack, Dinner, MidMorningSnack
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PrincipalTableViewCell else { return UITableViewCell() }
        
        var mealName = ""
        var recipe: Recipe
        
        switch indexPath.row {
        case 0:
            mealName = "Desayuno"
            recipe = dietDay.breakfast
        case 1:
            mealName = "Almuerzo"
            recipe = dietDay.lunch
        case 2:
            mealName = "Merienda"
            recipe = dietDay.snack
        case 3:
            mealName = "Cena"
            recipe = dietDay.dinner
        case 4:
            mealName = "Snack de Media Mañana"
            recipe = dietDay.midMorningSnack
        default:
            fatalError("Unexpected row index")
        }
        
        cell.imageViewCell.loadImage(from: recipe.image)
        let nameAttributedString = NSMutableAttributedString(string: "Nombre: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13)])
        nameAttributedString.append(NSAttributedString(string: recipe.name))
        cell.titleOneLabel.attributedText = nameAttributedString
        
        let foodAttributedString = NSMutableAttributedString(string: "Tipo Comida: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13)])
        foodAttributedString.append(NSAttributedString(string: recipe.mealType.rawValue))
        cell.titleSecondLabel.attributedText = foodAttributedString
        
        let timePreparationAttributedString = NSMutableAttributedString(string: "Tiempo Preparación: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13)])
        timePreparationAttributedString.append(NSAttributedString(string: String("\(recipe.preparationTime) min.")))
        cell.titleThirdLabel.attributedText = timePreparationAttributedString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedRecipe: Recipe
        
        switch indexPath.row {
        case 0:
            selectedRecipe = dietDay.breakfast
        case 1:
            selectedRecipe = dietDay.lunch
        case 2:
            selectedRecipe = dietDay.snack
        case 3:
            selectedRecipe = dietDay.dinner
        case 4:
            selectedRecipe = dietDay.midMorningSnack
        default:
            return
        }
        
        let vc = FoodDetailViewController(recipe: selectedRecipe)
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
        
        print(selectedRecipe)
    }
}
