//
//  Extension+UIImageView.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 30/4/24.
//

import UIKit

extension UIImageView {
    func loadImage(from urlString: String?) {
        // Check if the URL is valid
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        // Download the image
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            // Convert the downloaded data into an image
            if let image = UIImage(data: data) {
                // Update the UI on the main thread
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}
