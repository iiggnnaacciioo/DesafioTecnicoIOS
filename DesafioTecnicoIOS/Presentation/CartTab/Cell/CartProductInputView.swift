//
//  CartProductInputView.swift
//  DesafioTecnicoIOS
//
//  Created by Ignacio Schiefelbein on 01-09-24.
//

import UIKit

class CartProductInputView: UIView {
    //MARK: View components
    let stackView: UIStackView = UIBuilder.stackView(axis: .vertical, spacing: 12, alignment: .center)
    
    let removeButton: UIButton = UIBuilder.roundedTextClearButton(text: "Quitar")
    
    let quantityStack: UIStackView = UIBuilder.stackView(axis: .horizontal, spacing: 4, alignment: .fill, distribution: .equalCentering)
    
    let increaseButton: UIButton = UIBuilder.iconButton(systemName: "plus.circle.fill", iconSize: 30)
    
    let quantityLabel: UILabel = UIBuilder.singleLineLabel("", style: .title3, weight: .medium, alignment: .center)
    
    let decreaseButton: UIButton = UIBuilder.iconButton(systemName: "minus.circle.fill", iconSize: 30)

    //MARK: Properties
    var decreaseAction: (() -> ())?

    var increaseAction: (() -> ())?

    var deleteAction: (() -> ())?

    init() {
        super.init(frame: .zero)
        setupView()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(
        quantity: Int,
        decreaseAction: @escaping() -> (),
        increaseAction: @escaping() -> (),
        deleteAction: @escaping() -> ()
    ) {
        self.increaseAction = increaseAction
        self.decreaseAction = decreaseAction
        self.deleteAction = deleteAction
        quantityLabel.text = String(quantity)
        
        removeButton.isEnabled = true
        removeButton.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    @objc func decreaseButtonWasPressed() {
        decreaseAction?()
    }
    
    @objc func increaseButtonWasPressed() {
        increaseAction?()
    }
    
    @objc func removeButtonWasPressed() {
        disableButtons()
        deleteAction?()
    }
    
    private func disableButtons() {
        removeButton.layer.borderColor = UIColor.lightGray.cgColor
        removeButton.isEnabled = false
    }

    private func setupView() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(removeButton)
        stackView.addArrangedSubview(quantityStack)
        
        quantityStack.addArrangedSubview(decreaseButton)
        quantityStack.addArrangedSubview(quantityLabel)
        quantityStack.addArrangedSubview(increaseButton)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false

        stackView.pinTo(parent: self)
        
        NSLayoutConstraint.activate([
            removeButton.leadingAnchor.constraint(greaterThanOrEqualTo: stackView.leadingAnchor, constant: 32),
            removeButton.trailingAnchor.constraint(greaterThanOrEqualTo: stackView.trailingAnchor, constant: -32),
            removeButton.heightAnchor.constraint(equalToConstant: 44),

            quantityStack.leadingAnchor.constraint(greaterThanOrEqualTo: stackView.leadingAnchor, constant: 0),
            quantityStack.trailingAnchor.constraint(lessThanOrEqualTo: stackView.trailingAnchor, constant: 0),
            
            decreaseButton.widthAnchor.constraint(equalToConstant: 44),
            decreaseButton.widthAnchor.constraint(equalToConstant: 44),
            
            quantityLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
            
            increaseButton.widthAnchor.constraint(equalToConstant: 44),
            increaseButton.widthAnchor.constraint(equalToConstant: 44),
        ])
        
        decreaseButton.tintColor = UIColor.systemRed
        increaseButton.tintColor = UIColor.systemGreen
    }
    
    private func setupAction() {
        decreaseButton.addTarget(self, action: #selector(decreaseButtonWasPressed), for: .touchUpInside)
        increaseButton.addTarget(self, action: #selector(increaseButtonWasPressed), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removeButtonWasPressed), for: .touchUpInside)
    }
}
