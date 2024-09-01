//
//CartPresenter.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-09-01.
//Copyright © 2024 -. All rights reserved.
//

import Foundation

protocol CartPresenterProtocol {
    func present(products: [ProductResponse], purchaseIntents: [ProductPurchaseIntent], animated: Bool)
    func present(error: URLError)
}

class CartPresenter {
	weak var viewController: CartViewControllerProtocol?

	init(viewController: CartViewControllerProtocol?) {
		self.viewController = viewController
	}
}

extension CartPresenter: CartPresenterProtocol {
    func present(products: [ProductResponse], purchaseIntents: [ProductPurchaseIntent], animated: Bool) {
        print("eraser me now \(purchaseIntents)")

        var cartProducts: [CartProductModel] = []
        
        let productDict = Dictionary(uniqueKeysWithValues: products.map { ($0.id, $0) })
        
        // Map purchaseIntents to CartProductModel
        for intent in purchaseIntents {
            if let product = productDict[intent.productId] {
                let cartProduct = CartProductModel(product: product, quantity: intent.quantity)
                cartProducts.append(cartProduct)
            }
        }

        viewController?.show(cartProducts: cartProducts, animated: animated)
    }
    
    func present(error: URLError) {
        viewController?.showError(message: error.localizedDescription)
    }
}
