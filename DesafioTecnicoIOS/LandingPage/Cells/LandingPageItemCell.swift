//
//  LandingPageItemCell.swift
//  DesafioCodigoIOS
//
//  Created by Ignacio Schiefelbein on 29-08-24.
//

import UIKit

class LandingPageItemCell: UICollectionViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    //MARK: View components
    let stackView: UIStackView = UIBuilder.stackView(axis: .vertical, spacing: 0)
    
    let productImage: UIImageView = UIBuilder.imageView(image: nil)
    
    let spacer: UIView = UIBuilder.view(color: .red)
    
    let titleLabel: UILabel = UIBuilder.multilineLabel("", style: .subheadline, weight: .medium, alignment: .center)
    
    let priceStackView: UIStackView = UIBuilder.stackView(axis: .horizontal, spacing: 8, alignment: .center)
    
    let priceLabel: UILabel = UIBuilder.singleLineLabel(size: 14, weight: .regular)
    
    let addButton: UIButton =  UIBuilder.iconButton(systemName: "plus.circle", iconSize: 30)

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
        addProductAction?()
    }

    private func setupView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        productImage.translatesAutoresizingMaskIntoConstraints = false
        spacer.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(productImage)
        stackView.addArrangedSubview(spacer)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(priceStackView)
        stackView.addArrangedSubview(separator)
        
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(addButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            
            productImage.heightAnchor.constraint(equalToConstant: 90),
            productImage.widthAnchor.constraint(lessThanOrEqualTo: stackView.widthAnchor, constant: -64),
            
            titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
            
            priceStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 6),
            priceStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -6),
            
            addButton.topAnchor.constraint(equalTo: priceStackView.topAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 44),
            addButton.widthAnchor.constraint(equalToConstant: 44),
            addButton.bottomAnchor.constraint(equalTo: priceStackView.bottomAnchor),
            
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 8),
            separator.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -8)
        ])
        
        contentView.backgroundColor = .white
        
        stackView.setCustomSpacing(4, after: priceStackView)
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellWasTapped))
        contentView.addGestureRecognizer(tapGesture)
        
        addButton.addTarget(self, action: #selector(addProductWasTapped), for: .touchUpInside)
    }
}

extension LandingPageItemCell: LandingPageCellProtocol {
    func setup(title: String,
               price: String,
               imageURL: String,
               tapProductAction: @escaping() -> (),
               addProductAction: @escaping() -> ()) {
        self.tapProductAction = tapProductAction
        self.addProductAction = addProductAction

        titleLabel.text = title
        priceLabel.text = price
        
        productImage.image = nil
        productImage.loadImage(imageURL: imageURL)
    }
}
