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

	let worker: CartWorkerProtocol

    let localStorageWorker: LocalStorageWorkerProtocol
    
    var productResponse: [ProductResponse] = []

	init(presenter: CartPresenterProtocol, worker: CartWorkerProtocol, localStorage: LocalStorageWorkerProtocol) {
		self.presenter = presenter
        self.worker = worker
        self.localStorageWorker = localStorage
	}
}

extension CartInteractor: CartInteractorProtocol {
    func loadStoredPurchases(animated: Bool) {
        Task { @MainActor in
            let purchaseIntents = await localStorageWorker.loadStoredCart()
            let productIds: [Int] = purchaseIntents.map {
                $0.productId
            }
            
            do {
                let products = try await withThrowingTaskGroup(of: ProductResponse.self, returning: [ProductResponse].self) { taskGroup in
                    for productId in productIds {
                        taskGroup.addTask {
                            try await self.worker.getProductDetails(productId: productId)
                        }
                    }

                    var products = [ProductResponse]()

                    while let product = try await taskGroup.next() {
                        products.append(product)
                    }
                    return products
                }
                productResponse = products
                presenter.present(products: products, purchaseIntents: purchaseIntents, animated: animated)
            } catch {
                presenter.present(error: error as? URLError ?? URLError(.badServerResponse))
            }
        }
    }
    
    func addOneToCart(productId: Int) {
        Task { @MainActor in
            await localStorageWorker.addOne(productId: productId)
            let purchaseIntents = await localStorageWorker.loadStoredCart()
            presenter.present(products: productResponse, purchaseIntents: purchaseIntents, animated: false)
        }
    }
    
    func removeOneFromCart(productId: Int) {
        Task {  @MainActor in
            await localStorageWorker.removeOne(productId: productId)
            let purchaseIntents = await localStorageWorker.loadStoredCart()
            presenter.present(products: productResponse, purchaseIntents: purchaseIntents, animated: false)
        }
    }
    
    func delete(productId: Int) {
        Task {  @MainActor in
            await localStorageWorker.delete(productId: productId)
            loadStoredPurchases(animated: true)
        }
    }
}
