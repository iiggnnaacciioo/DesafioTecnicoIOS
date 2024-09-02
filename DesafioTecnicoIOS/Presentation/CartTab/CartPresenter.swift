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

        var cartProducts: [CartProductModel] = []
        
        let productDict = Dictionary(uniqueKeysWithValues: products.map { ($0.id, $0) })
        
        
        var totalPrice: Double = 0
        for intent in purchaseIntents {
            if let product = productDict[intent.productId] {
                totalPrice += product.price * Double(intent.quantity)
                let cartProduct = CartProductModel(product: product, quantity: intent.quantity)
                cartProducts.append(cartProduct)
            }
        }
        
        let priceCL = CurrencyHelper.formatDollarToCLP(amount: totalPrice, exchangeRate: CurrencyHelper.dollarToCLPRate)
        let text = "Total Amount: \(priceCL) CLP"

        viewController?.show(cartProducts: cartProducts, totalAmount: text, animated: animated)
    }
    
    func present(error: URLError) {
        viewController?.showError(message: error.localizedDescription)
    }
}
