//
//LandingPageInteractor.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-08-29.
//Copyright © 2024 -. All rights reserved.
//

import Foundation

protocol LandingPageInteractorProtocol {
    func fetchProducts(category: String?)
    func loadPurchaseIntents()
    func addToCart(productId: Int)
}

class LandingPageInteractor {
	let presenter: LandingPagePresenterProtocol
    
    let apiClient: FakeStoreApiClientProtocol

    let localStorage: LocalStorageProtocol

	init(presenter: LandingPagePresenterProtocol, 
         apiClient: FakeStoreApiClientProtocol,
         localStorage: LocalStorageProtocol) {
        self.presenter = presenter
        self.apiClient = apiClient
        self.localStorage = localStorage
	}
}

extension LandingPageInteractor: LandingPageInteractorProtocol {
    func fetchProducts(category: String?) {
        Task {  @MainActor in
            do {
                var products: [ProductResponse]
                if let strongCategory = category {
                    products = try await apiClient.getProductsBy(category: strongCategory)
                } else {
                    products = try await apiClient.getProducts()
                }
                presenter.present(products: products)
            } catch {
                let urlError = error as? URLError ?? URLError(.unknown)
                presenter.present(error: urlError)
            }
        }

    }
    
    func addToCart(productId: Int) {
        Task {  @MainActor in
            await localStorage.addOne(productId: productId)
            loadPurchaseIntents()
        }
    }
    
    func loadPurchaseIntents() {
        Task { @MainActor in
            let purchaseIntents = await localStorage.loadStoredCart()
            presenter.present(purchaseIntents: purchaseIntents)
        }
    }
}
