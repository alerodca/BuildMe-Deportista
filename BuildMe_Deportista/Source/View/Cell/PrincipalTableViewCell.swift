//
//  PrincipalTableViewCell.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 29/5/24.
//

import UIKit

class PrincipalTableViewCell: UITableViewCell {

    @IBOutlet var imageViewCell: UIImageView!
    @IBOutlet var titleOneLabel: UILabel!
    @IBOutlet var titleSecondLabel: UILabel!
    @IBOutlet var titleThirdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageViewCell.layer.cornerRadius = 10
        imageViewCell.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
