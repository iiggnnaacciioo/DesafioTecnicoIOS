//
//ProductDetailPageView.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-08-31.
//Copyright © 2024 -. All rights reserved.
//

import UIKit

protocol ProductDetailPageViewProtocol: UIView {
    func show(product: ProductModel)
    func animateOutro()
}

protocol ProductDetailPageViewDelegate: AnyObject {
    func close()
    func addProductToCart()
}

class ProductDetailPageView: UIView {
    //MARK: View components
    let loadingView = UIBuilder.loadingView()
    
    let container = UIBuilder.view(color: .white)
    
    let stackView = UIBuilder.stackView(axis: .vertical, spacing: 8, alignment: .fill)
    
    let closeButtonContainer: UIView = UIBuilder.view(color: .clear)
    
    let closeButton: UIButton =  UIBuilder.iconButton(systemName: "xmark", iconSize: 16)
    
    lazy var productDescription: ProductDetailDescriptionView = ProductDetailDescriptionView { [weak self] in
        self?.delegate?.addProductToCart()
    }

    //MARK: Properties
    var topContainerConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    var bottomContainerConstraint: NSLayoutConstraint = NSLayoutConstraint()

	weak var delegate: ProductDetailPageViewDelegate?

    //MARK: Life cycle
	init(delegate: ProductDetailPageViewDelegate) {
        self.delegate = delegate
		super.init(frame: .zero)
        setupView()
        setupActions()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        container.roundTopCorners(radius: 20)
        show(isLoading:true)
    }
    
    //MARK: Actions
    @objc func closeButtonWasTapped() {
        animateOutro()
    }
    
    private func setupView() {
        let window = UIApplication.shared.windows.first
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0

        addSubview(container)
        addSubview(loadingView)

        container.addSubview(stackView)

        stackView.addArrangedSubview(closeButtonContainer)
        stackView.addArrangedSubview(productDescription)

        closeButtonContainer.addSubview(closeButton)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        productDescription.translatesAutoresizingMaskIntoConstraints = false

        topContainerConstraint = container.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 600)
        bottomContainerConstraint = container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 600)

        NSLayoutConstraint.activate([
            topContainerConstraint,
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomContainerConstraint,

            stackView.topAnchor.constraint(equalTo: container.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -(bottomPadding + 8)),
            
            closeButton.topAnchor.constraint(equalTo: closeButtonContainer.topAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.trailingAnchor.constraint(equalTo: closeButtonContainer.trailingAnchor),
            closeButton.bottomAnchor.constraint(equalTo: closeButtonContainer.bottomAnchor),
            
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        closeButton.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        backgroundColor = UIColor.white.withAlphaComponent(0.4)

        closeButton.tintColor = .darkGray
    }
        
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeButtonWasTapped), for: .touchUpInside)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(closeButtonWasTapped))
        swipeGesture.direction = .down
        self.addGestureRecognizer(swipeGesture)
    }
    
    private func show(isLoading: Bool) {
        if isLoading {
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
        }
    }
    
    private func animateIntro() {
        self.layoutIfNeeded()

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.01, animations: { [weak self] in
            self?.topContainerConstraint.constant = 0
            self?.bottomContainerConstraint.constant = 0
            self?.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
            self?.layoutIfNeeded()
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        if !container.frame.contains(touch.location(in: self)) {
            animateOutro()
        }
    }
}

extension ProductDetailPageView: ProductDetailPageViewProtocol {
    func show(product: ProductModel) {
        productDescription.setup(
            title: product.title,
            price: product.formattedPrice,
            description: product.description,
            imageURL: product.imageURL,
            rating: product.rating
        )
                

        show(isLoading:false)
        
        DispatchQueue.main.async { [weak self] in
            self?.animateIntro()
        }
    }
    
    func animateOutro() {
        self.layoutIfNeeded()
        let containerHeight = container.bounds.height

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.01) { [weak self] in
            self?.topContainerConstraint.constant = containerHeight
            self?.bottomContainerConstraint.constant = containerHeight
            self?.backgroundColor = UIColor.darkGray.withAlphaComponent(0)
            self?.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.delegate?.close()
        }
    }
}
