//
//CartViewController.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-09-01.
//Copyright © 2024 -. All rights reserved.
//

import UIKit

protocol CartViewControllerProtocol: AnyObject {
    func show(cartProducts: [CartProductModel], totalAmount: String, animated: Bool)
    func showError(message: String)
}

class CartViewController: UIViewController {
	var cartView: CartViewProtocol?

	var interactor: CartInteractorProtocol?
    
    let closeAction: () -> ()

	init(closeAction: @escaping() -> ()) {
        self.closeAction = closeAction
		super.init(nibName: nil, bundle: nil)
		cartView = CartView(delegate: self)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView() {
		super.loadView()
		view = cartView
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Cart"
        self.navigationController?.navigationBar.topItem?.title = "Home"
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            closeAction()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartView?.show(isLoading: true)
        interactor?.loadStoredPurchases(animated: true)
    }
    
    private func showDeleteProductAlert(productId: Int) {
        let alert = UIAlertController(title: nil, message: "Quieres eliminar este producto del carro?", preferredStyle: .alert)
        alert.overrideUserInterfaceStyle = .light
        alert.addAction(UIAlertAction(title: "Si", style: .destructive, handler: { [weak self] _ in
            self?.removeProduct(productId: productId)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default))
        present(alert, animated: true)
    }
}

extension CartViewController: CartViewControllerProtocol {
    func show(cartProducts: [CartProductModel], totalAmount: String, animated: Bool) {
        cartView?.show(isLoading: false)
        cartView?.show(cartProducts: cartProducts, totalAmount: totalAmount, animated: animated)
    }
    
    func showError(message: String) {
        cartView?.show(isLoading: false)
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.overrideUserInterfaceStyle = .light
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

extension CartViewController: CartViewDelegate {
    func removeProduct(productId: Int) {
        cartView?.show(isLoading: true)
        interactor?.delete(productId: productId)
    }
    
    func addUnit(productId: Int) {
        interactor?.addOneToCart(productId: productId)
    }
    
    func removeUnit(productId: Int, currentQuantity: Int) {
        if currentQuantity <= 1 {
            showDeleteProductAlert(productId: productId)
        } else {
            interactor?.removeOneFromCart(productId: productId)
        }
    }
    
    func goBack() {
        closeAction()
        navigationController?.popViewController(animated: true)
    }
}
