//
//LandingPagePresenter.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-08-29.
//Copyright © 2024 -. All rights reserved.
//

import Foundation

protocol LandingPagePresenterProtocol {
    func present(products: [ProductResponse])
    func present(error: URLError)
    func present(purchaseIntents: [ProductPurchaseIntent])
}

class LandingPagePresenter {
	weak var viewController: LandingPageViewControllerProtocol?

	init(viewController: LandingPageViewControllerProtocol?) {
		self.viewController = viewController
	}
}

extension LandingPagePresenter: LandingPagePresenterProtocol {
    func present(products: [ProductResponse]) {
        guard !products.isEmpty else {
            viewController?.showError(message: "No se encontraron productos")
            return
        }
        
        var items = products.map {
            ProductModel(product: $0)
        }.sorted {
            $0.highlightScore > $1.highlightScore
        }
        
        let highlightedItem = items.removeFirst()
        
        viewController?.show(items: items, highlightedItem: highlightedItem)
    }
    
    func present(purchaseIntents: [ProductPurchaseIntent]) {
        let totalQuantity = purchaseIntents.reduce(0) { $0 + $1.quantity }
        let quantityString = totalQuantity == 0 ? nil : "\(totalQuantity)"
        viewController?.updateCartItem(quantity: quantityString)
    }
    
    func present(error: URLError) {
        viewController?.showError(message: error.localizedDescription)
    }
}
