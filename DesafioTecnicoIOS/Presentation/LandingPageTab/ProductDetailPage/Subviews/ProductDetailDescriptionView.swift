//
//  ProductDetailDescriptionView.swift
//  DesafioCodigoIOS
//
//  Created by Ignacio Schiefelbein on 31-08-24.
//

import UIKit

class ProductDetailDescriptionView: UIStackView {
    //MARK: View components
    let productImageContainer: UIView = UIBuilder.view(color: .clear)

    let productImage: UIImageView = UIBuilder.imageView(image: nil)
    
    let titleStack = UIBuilder.stackView(axis: .horizontal, spacing: 8, alignment: .top)

    let titleLabel = UIBuilder.multilineLabel("-", style: .title2, weight: .bold, alignment: .left)

    let priceLabelContainer: UIView = UIBuilder.view(color: .clear)

    let priceLabel = UIBuilder.singleLineLabel("", size: 16, weight: .semibold, alignment: .right)

    let descriptionLabel = UIBuilder.multilineLabel("-", style: .subheadline, weight: .regular, alignment: .left, numberOfLines: 0)
    
    let bottomStack = UIBuilder.stackView(axis: .horizontal, spacing: 8, alignment: .fill, distribution: .equalSpacing)
    
    let ratingStars: RatingStarsView = RatingStarsView()
    
    let addButton: UIButton =  UIBuilder.iconButton(systemName: "plus.circle", iconSize: 36)

    //MARK: Properties
    let addProductAction: () -> ()
    
    //MARK: Life cycle
    init(addProductAction: @escaping() -> ()) {
        self.addProductAction = addProductAction
        super.init(frame: .zero)
        setupView()
        setupActions()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(title: String, price: String, description: String, imageURL: String, rating: Double) {
        titleLabel.text = title
        priceLabel.text = price
        descriptionLabel.text = description
        
        productImage.loadImage(imageURL: imageURL)
        
        ratingStars.setup(rating: rating)
    }
    
    //MARK: Actions
    @objc func addButtonWasTapped() {
        addProductAction()
    }
    
    private func setupView() {
        axis = .vertical
        spacing = 8
        
        addArrangedSubview(productImageContainer)
        addArrangedSubview(titleStack)
        addArrangedSubview(descriptionLabel)
        addArrangedSubview(bottomStack)

        titleStack.addArrangedSubview(titleLabel)
        titleStack.addArrangedSubview(priceLabelContainer)
        
        priceLabelContainer.addSubview(priceLabel)
        
        productImageContainer.addSubview(productImage)
        
        bottomStack.addArrangedSubview(ratingStars)
        bottomStack.addArrangedSubview(addButton)

        productImage.translatesAutoresizingMaskIntoConstraints = false
        productImageContainer.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            productImageContainer.heightAnchor.constraint(lessThanOrEqualToConstant: 200),
            
            productImage.topAnchor.constraint(equalTo: productImageContainer.topAnchor),
            productImage.leadingAnchor.constraint(greaterThanOrEqualTo: productImageContainer.leadingAnchor),
            productImage.centerXAnchor.constraint(greaterThanOrEqualTo: productImageContainer.centerXAnchor),
            productImage.trailingAnchor.constraint(lessThanOrEqualTo: productImageContainer.trailingAnchor),
            productImage.bottomAnchor.constraint(equalTo: productImageContainer.bottomAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: priceLabelContainer.topAnchor, constant: 6),
            priceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: priceLabelContainer.leadingAnchor),
            priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabelContainer.trailingAnchor),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: priceLabelContainer.bottomAnchor),
        ])
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        productImage.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    func setupActions() {
        addButton.addTarget(self, action: #selector(addButtonWasTapped), for: .touchUpInside)
    }
}
