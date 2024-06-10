//
//  CustomTableViewCell.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 1/6/24.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    // Creación de los componentes UI
    let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // Configuración de la vista
    private func setupViews() {
        contentView.addSubview(customImageView)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        // Configuración de las restricciones para customImageView
        NSLayoutConstraint.activate([
            customImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            customImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            customImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            customImageView.widthAnchor.constraint(equalToConstant: 100),
            customImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Configuración de las restricciones para stackView
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
