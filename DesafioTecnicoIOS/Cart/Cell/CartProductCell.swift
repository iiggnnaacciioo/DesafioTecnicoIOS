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
    let stackView: UIStackView = UIBuilder.stackView(axis: .horizontal, spacing: 0, alignment: .top, distribution: .fill)

    let productImageContainer: UIView = UIBuilder.view(color: .clear)

    let productImage: UIImageView = UIBuilder.imageView(image: nil)
        
    let infoStackView: UIStackView = UIBuilder.stackView(axis: .vertical, spacing: 8, alignment: .fill)
        
    let productLabel: UILabel = UIBuilder.multilineLabel("", style: .headline, weight: .medium, alignment: .left, numberOfLines: 5)

    let priceLabel: UILabel = UIBuilder.singleLineLabel(size: 14, weight: .regular)
    
    let productInputView: CartProductInputView = CartProductInputView()

    let separator: UIView = UIBuilder.view(color: UIColor(white: 0.8, alpha: 1))
    
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
        separator.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)
        contentView.addSubview(separator)

        stackView.addArrangedSubview(productImageContainer)
        stackView.addArrangedSubview(infoStackView)
        
        productImageContainer.addSubview(productImage)
        
        infoStackView.addArrangedSubview(productLabel)
        infoStackView.addArrangedSubview(priceLabel)
        infoStackView.addArrangedSubview(productInputView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
                        
            productImageContainer.heightAnchor.constraint(equalToConstant: 100),
            
            productImage.heightAnchor.constraint(lessThanOrEqualTo: productImageContainer.heightAnchor, constant: -16),
            productImage.widthAnchor.constraint(lessThanOrEqualTo: productImageContainer.widthAnchor, constant: -16),
            productImage.centerXAnchor.constraint(equalTo: productImageContainer.centerXAnchor),
            productImage.centerYAnchor.constraint(equalTo: productImageContainer.centerYAnchor),

            infoStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5, constant: -16),

            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 8),
            separator.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -8),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        contentView.backgroundColor = .white
    }
}
