//
//  CartTotalAmountView.swift
//  DesafioTecnicoIOS
//
//  Created by Ignacio Schiefelbein on 01-09-24.
//

import UIKit

class CartTotalAmountView: UIView {
    //MARK: View Components
    let stackView = UIBuilder.stackView(axis: .vertical, spacing: 16, alignment: .center)
    
    let titleLabel = UIBuilder.singleLineLabel(" ", size: 29, weight: .bold, alignment: .left)
    
    let button = UIBuilder.roundedTextFilledButton(text: "Purchase")
    
    //MARK: Life cycle
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSizeMake(0, 4 / 6)
        layer.shadowRadius = 4
    }
    
    func setup(text: String, isEnabled: Bool) {
        titleLabel.text = text
        button.isEnabled = isEnabled
        button.backgroundColor = isEnabled ? UIColor.systemBlue : UIColor.lightGray
    }
    
    private func setupView() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(button)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 8),
            
            titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            
            button.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -32),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        backgroundColor = .white
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        
        button.backgroundColor = UIColor.lightGray
        button.isEnabled = false
    }
}
