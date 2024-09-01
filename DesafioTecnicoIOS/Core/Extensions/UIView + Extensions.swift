//
//  UIView + Extensions.swift
//  DesafioCodigoIOS
//
//  Created by Ignacio Schiefelbein on 31-08-24.
//

import UIKit

extension UIView {
    func roundTopCorners(radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func pinTo(parent: UIView) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: parent.topAnchor),
            self.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
        ])
    }
    
    func addShadow() {
        let shadowSize: CGFloat = 4
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSizeMake(0, shadowSize / 6)
        layer.shadowRadius = shadowSize
    }
    
    func gradient(topColor: UIColor, bottomColor: UIColor) {
        let gradient = CAGradientLayer()

        gradient.frame = bounds
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]

        layer.insertSublayer(gradient, at: 0)
    }
}
