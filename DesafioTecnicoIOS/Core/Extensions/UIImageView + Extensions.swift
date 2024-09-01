//
//  UIImageView + Extensions.swift
//  DesafioCodigoIOS
//
//  Created by Ignacio Schiefelbein on 31-08-24.
//

import UIKit

extension UIImageView {
    func loadImage(imageURL: String) {
        let url: URL = URL(string: imageURL)!
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            if let strongData = data {
                self?.showLoadedImage(image: UIImage(data: strongData))
                return
            }
        }.resume()
    }
    
    func showLoadedImage(image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            self?.image = image
        }
    }
}
