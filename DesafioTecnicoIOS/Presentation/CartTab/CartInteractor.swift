//
//CartInteractor.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-09-01.
//Copyright © 2024 -. All rights reserved.
//

import Foundation

protocol CartInteractorProtocol {
    func loadStoredPurchases(animated: Bool)
    func addOneToCart(productId: Int)
    func removeOneFromCart(productId: Int)
    func delete(productId: Int)
}

class CartInteractor {
	let presenter: CartPresenterProtocol

    let apiClient: FakeStoreApiClientProtocol

    let localStorage: LocalStorageProtocol
    ///ProductResponse array cache to fetch that data only once each time the view is presented
    var productsResponse: [ProductResponse] = []

	init(presenter: CartPresenterProtocol, apiClient: FakeStoreApiClientProtocol, localStorage: LocalStorageProtocol) {
		self.presenter = presenter
        self.apiClient = apiClient
        self.localStorage = localStorage
	}
}

extension CartInteractor: CartInteractorProtocol {
    func loadStoredPurchases(animated: Bool) {
        Task { @MainActor in
            let purchaseIntents = await localStorage.loadStoredCart()
            let productIds: [Int] = purchaseIntents.map {
                $0.productId
            }
            
            guard productsResponse.isEmpty else {
                presenter.present(products: productsResponse, purchaseIntents: purchaseIntents, animated: animated)
                return
            }
            
            do {
                let products = try await withThrowingTaskGroup(of: ProductResponse.self, returning: [ProductResponse].self) { taskGroup in
                    for productId in productIds {
                        taskGroup.addTask {
                            try await self.apiClient.getProductDetails(productId: productId)
                        }
                    }

                    var products = [ProductResponse]()

                    while let product = try await taskGroup.next() {
                        products.append(product)
                    }
                    return products
                }
                productsResponse = products
                presenter.present(products: products, purchaseIntents: purchaseIntents, animated: animated)
            } catch {
                presenter.present(error: error as? URLError ?? URLError(.badServerResponse))
            }
        }
    }
    
    func addOneToCart(productId: Int) {
        Task { @MainActor in
            await localStorage.addOne(productId: productId)
            let purchaseIntents = await localStorage.loadStoredCart()
            presenter.present(products: productsResponse, purchaseIntents: purchaseIntents, animated: false)
        }
    }
    
    func removeOneFromCart(productId: Int) {
        Task {  @MainActor in
            await localStorage.removeOne(productId: productId)
            let purchaseIntents = await localStorage.loadStoredCart()
            presenter.present(products: productsResponse, purchaseIntents: purchaseIntents, animated: false)
        }
    }
    
    func delete(productId: Int) {
        Task {  @MainActor in
            await localStorage.delete(productId: productId)
            loadStoredPurchases(animated: true)
        }
    }
}
