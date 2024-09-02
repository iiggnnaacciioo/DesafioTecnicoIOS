//
//  LandingPageHighlightCell.swift
//  DesafioCodigoIOS
//
//  Created by Ignacio Schiefelbein on 30-08-24.
//

import UIKit

class LandingPageHighlightCell: UICollectionViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    //MARK: View components
    let stackView: UIStackView = UIBuilder.stackView(axis: .horizontal, spacing: 0, alignment: .fill, distribution: .fill)

    let productImageContainer: UIView = UIBuilder.view(color: .clear)

    let productImage: UIImageView = UIBuilder.imageView(image: nil)

    let spacer: UIView = UIBuilder.view(color: .clear)
        
    let infoStackView: UIStackView = UIBuilder.stackView(axis: .vertical, spacing: 8, alignment: .fill)
    
    let titleLabel: UILabel = UIBuilder.multilineLabel("", style: .title2, weight: .bold, alignment: .left)
    
    let productLabel: UILabel = UIBuilder.multilineLabel("", style: .subheadline, weight: .medium, alignment: .left, numberOfLines: 5)

    let priceLabel: UILabel = UIBuilder.singleLineLabel("", size: 14, weight: .regular)
    
    let buttonContainer: UIView = UIBuilder.view(color: .clear)
    
    let addButton: UIButton =  UIBuilder.iconButton(systemName: "plus.circle", iconSize: 36)

    let separator: UIView = UIBuilder.view(color: UIColor(white: 0.8, alpha: 1))
    
    //MARK: Properties
    var tapProductAction: (() -> ())?
    
    var addProductAction: (() -> ())?

    //MARK: Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Actions
    @objc func cellWasTapped() {
        tapProductAction?()
    }
    
    @objc func addProductWasTapped() {
        disableAddButtonTemporarily()
        addProductAction?()
    }
    
    private func setupView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        productImageContainer.translatesAutoresizingMaskIntoConstraints = false
        productImage.translatesAutoresizingMaskIntoConstraints = false
        spacer.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        productLabel.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)
        contentView.addSubview(separator)

        stackView.addArrangedSubview(productImageContainer)
        stackView.addArrangedSubview(infoStackView)
        
        productImageContainer.addSubview(productImage)
        
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(productLabel)
        infoStackView.addArrangedSubview(priceLabel)
        infoStackView.addArrangedSubview(spacer)
        infoStackView.addArrangedSubview(buttonContainer)
        
        buttonContainer.addSubview(addButton)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            
            productImage.heightAnchor.constraint(equalTo: stackView.heightAnchor, constant: -16),
            productImage.widthAnchor.constraint(lessThanOrEqualTo: infoStackView.widthAnchor, constant: -32),
            productImage.centerXAnchor.constraint(equalTo: productImageContainer.centerXAnchor),
            productImage.centerYAnchor.constraint(equalTo: productImageContainer.centerYAnchor),

            infoStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5, constant: -16),

            addButton.heightAnchor.constraint(equalToConstant: 44),
            addButton.widthAnchor.constraint(equalToConstant: 44),
            addButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor),
            addButton.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor),
            addButton.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor, constant: -8),

            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 8),
            separator.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -8),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellWasTapped))
        contentView.addGestureRecognizer(tapGesture)
        
        addButton.addTarget(self, action: #selector(addProductWasTapped), for: .touchUpInside)
    }
}

extension LandingPageHighlightCell: LandingPageCellProtocol {
    func setup(title: String,
               price: String,
               imageURL: String,
               tapProductAction: @escaping() -> (),
               addProductAction: @escaping() -> ()) {
        self.tapProductAction = tapProductAction
        self.addProductAction = addProductAction
        
        titleLabel.text = "Destacado"
        productLabel.text = title
        priceLabel.text = price
        
        productImage.image = nil
        productImage.loadImage(imageURL: imageURL)
    }
}
