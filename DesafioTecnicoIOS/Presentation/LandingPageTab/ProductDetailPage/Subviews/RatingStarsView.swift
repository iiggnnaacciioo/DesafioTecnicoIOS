//
//  RatingStarsView.swift
//  DesafioCodigoIOS
//
//  Created by Ignacio Schiefelbein on 31-08-24.
//

import UIKit

class RatingStarsView: UIView {
    let stackView = UIBuilder.stackView(axis: .horizontal, spacing: 4)
    
    var stars: [StarView] = []
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(rating: Double) {
        stars.forEach {
            $0.setup(value: 0)
        }
        
        let roundedUp = Double(rating.rounded(.up))
        for i in 0..<Int(roundedUp) {
            let star = stars[i]
            var value: Double = 1
            if i == Int(roundedUp - 1) {
                value = 1 - (roundedUp - rating)
                value = Double(Int(value * 4)) / 4.0
            }
            star.setup(value: value)
        }
    }
    
    private func setupView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        for _ in 0..<5 {
            let star = StarView()
            star.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(star)
            stars.append(star)
        }
        
        stackView.pinTo(parent: self)
    }
}

//MARK: StarView
class StarView: UIView {
    let backImage = UIBuilder.imageView(image: UIImage(systemName: "star.fill"))
    
    let frontImage = UIBuilder.imageView(image: UIImage(systemName: "star"))
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(value: Double) {
        if value == 0 {
            backImage.isHidden = true
        } else {
            let maskLayer = CALayer()
            maskLayer.frame = CGRect(x: 0,
                                     y: 0,
                                     width: backImage.bounds.width * value,
                                     height: backImage.bounds.height)
            maskLayer.backgroundColor = UIColor.black.cgColor
            backImage.layer.mask = maskLayer
            backImage.isHidden = false
        }
    }
    
    private func setupView() {
        backImage.translatesAutoresizingMaskIntoConstraints = false
        frontImage.translatesAutoresizingMaskIntoConstraints = false

        addSubview(backImage)
        addSubview(frontImage)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 24),
            widthAnchor.constraint(equalToConstant: 24)
        ])
        
        backImage.pinTo(parent: self)
        frontImage.pinTo(parent: self)
        
        let color = UIColor(white: 0.1, alpha: 1)
        backImage.tintColor = color
        frontImage.tintColor = color
        
        backImage.isHidden = true
    }
}
