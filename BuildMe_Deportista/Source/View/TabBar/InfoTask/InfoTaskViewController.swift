//
//  InfoTaskViewController.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 1/6/24.
//

import UIKit
import Firebase
import JGProgressHUD

class InfoTaskViewController: UIViewController {
    
    @IBOutlet var backView: UIView!
    @IBOutlet var tableView: UITableView!
    
    private var viewModel = InfoTaskViewModel()
    private let emptyTasksLabel: UILabel = {
        let label = UILabel()
        label.text = "Todavía no tienes ninguna tarea completada"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialConfigure()
        configureViewModel()
        viewModel.fetchData()
    }
    
    private func initialConfigure() {
        view.applyBlueRedGradient()
        
        backView.layer.cornerRadius = 15
        backView.layer.masksToBounds = true
        
        let backImage = UIImage(systemName: "arrow.backward")
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(dismissSelf))
        backButton.tintColor = .white
        backButton.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white],
            for: .normal)
        navigationItem.leftBarButtonItem = backButton
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        
        view.addSubview(emptyTasksLabel)
        NSLayoutConstraint.activate([
            emptyTasksLabel.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            emptyTasksLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor)
        ])
        emptyTasksLabel.leadingAnchor.constraint(greaterThanOrEqualTo: backView.leadingAnchor, constant: 16).isActive = true
        emptyTasksLabel.trailingAnchor.constraint(lessThanOrEqualTo: backView.trailingAnchor, constant: -16).isActive = true
        
        emptyTasksLabel.isHidden = true
    }
    
    private func configureViewModel() {
        viewModel.reloadDataHandler = { [weak self] in
            self?.tableView.reloadData()
            self?.emptyTasksLabel.isHidden = !(self?.viewModel.tasks.isEmpty ?? true)
        }
        
        viewModel.showAlertHandler = { [weak self] title, message, isError in
            DispatchQueue.main.async {
                let hud = JGProgressHUD(style: .dark)
                hud.indicatorView = isError ? JGProgressHUDErrorIndicatorView() : JGProgressHUDSuccessIndicatorView()
                hud.textLabel.text = title
                hud.detailTextLabel.text = message
                hud.interactionType = .blockAllTouches
                hud.show(in: self?.view ?? UIView())
                hud.dismiss(afterDelay: 3, animated: true)
            }
        }
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}

extension InfoTaskViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        
        let task = viewModel.tasks[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        cell.titleLabel.text = "Fecha: \(dateFormatter.string(from: task.date))"
        cell.subtitleLabel.text = "Observaciones: \(task.observations)"
        
        switch task.typeTask {
        case .diet:
            if let image = UIImage(systemName: "fork.knife.circle") {
                let tintedImage = image.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
                    .withRenderingMode(.alwaysOriginal)
                    .withConfiguration(UIImage.SymbolConfiguration(pointSize: 32))
                cell.customImageView.image = tintedImage
            }
        case .workout:
            if let workout = UIImage(systemName: "figure.walk.circle") {
                let tintedImage = workout.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
                    .withRenderingMode(.alwaysOriginal)
                    .withConfiguration(UIImage.SymbolConfiguration(pointSize: 32))
                cell.customImageView.image = tintedImage
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteTask(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = viewModel.tasks[indexPath.row]
        let popupVC = PopupViewController(completedTask: task)
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: true, completion: nil)
    }
}

