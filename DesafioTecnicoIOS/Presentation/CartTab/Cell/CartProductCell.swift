//
//  CartProductCell.swift
//  DesafioTecnicoIOS
//
//  Created by Ignacio Schiefelbein on 01-09-24.
//

import UIKit

class CartProductCell: UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    //MARK: View components
    let stackView: UIStackView = UIBuilder.stackView(axis: .horizontal, spacing: 0, alignment: .fill, distribution: .fillEqually)

    let productImageContainer: UIView = UIBuilder.view(color: .clear)

    let productImage: UIImageView = UIBuilder.imageView(image: nil)
        
    let infoStackView: UIStackView = UIBuilder.stackView(axis: .vertical, spacing: 12, alignment: .fill, distribution: .fill)
        
    let productLabel: UILabel = UIBuilder.multilineLabel("", style: .headline, weight: .medium, alignment: .left, numberOfLines: 5)

    let priceLabel: UILabel = UIBuilder.singleLineLabel("", style: .subheadline, weight: .regular)
    
    let productInputView: CartProductInputView = CartProductInputView()
    
    //MARK: Properties
    var imageURL: String = ""
    
    var increaseQuantity: (() -> ())?

    var decreaseQuantity: (() -> ())?
    
    var removeProduct: (() -> ())?

    //MARK: Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(title: String,
               price: String,
               imageURL: String,
               quantity: Int,
               increaseQuantity: @escaping() -> (),
               decreaseQuantity: @escaping() -> (),
               removeProduct: @escaping() -> ()) {
        self.increaseQuantity = increaseQuantity
        self.decreaseQuantity = decreaseQuantity
        self.removeProduct = removeProduct

        productLabel.text = title
        priceLabel.text = price
        
        if self.imageURL != imageURL {
            productImage.image = nil
            productImage.loadImage(imageURL: imageURL)
            self.imageURL = imageURL
        }
        
        productInputView.setup(
            quantity: quantity,
            decreaseAction: decreaseQuantity,
            increaseAction: increaseQuantity, 
            deleteAction: removeProduct
        )
    }
    
    private func setupView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        productImageContainer.translatesAutoresizingMaskIntoConstraints = false
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productLabel.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        productInputView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)

        stackView.addArrangedSubview(productImageContainer)
        stackView.addArrangedSubview(infoStackView)
        
        productImageContainer.addSubview(productImage)
        
        infoStackView.addArrangedSubview(productLabel)
        infoStackView.addArrangedSubview(priceLabel)
        infoStackView.addArrangedSubview(productInputView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            productImage.topAnchor.constraint(greaterThanOrEqualTo: productImageContainer.topAnchor, constant: 24),
            productImage.bottomAnchor.constraint(lessThanOrEqualTo: productImageContainer.bottomAnchor, constant: -24),
            productImage.leadingAnchor.constraint(equalTo: productImageContainer.leadingAnchor, constant: 24),
            productImage.trailingAnchor.constraint(equalTo: productImageContainer.trailingAnchor, constant: -24),
        ])
        
        productImage.setContentHuggingPriority(.defaultLow, for: .vertical)
        productImage.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        infoStackView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        infoStackView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        contentView.backgroundColor = .white
    }
}
