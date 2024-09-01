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

    let worker: LandingPageWorkerProtocol

    let localStorageWorker: LocalStorageWorkerProtocol

	init(presenter: LandingPagePresenterProtocol, 
         worker: LandingPageWorkerProtocol,
         localStorageWorker: LocalStorageWorkerProtocol) {
		self.presenter = presenter
        self.worker = worker
        self.localStorageWorker = localStorageWorker
	}
}

extension LandingPageInteractor: LandingPageInteractorProtocol {
    func fetchProducts(category: String?) {
        Task {  @MainActor in
            do {
                var products: [ProductResponse]
                if let strongCategory = category {
                    products = try await worker.getProductsBy(category: strongCategory)
                } else {
                    products = try await worker.getProducts()
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
            await localStorageWorker.addOne(productId: productId)
            loadPurchaseIntents()
        }
    }
    
    func loadPurchaseIntents() {
        Task { @MainActor in
            let purchaseIntents = await localStorageWorker.loadStoredCart()
            presenter.present(purchaseIntents: purchaseIntents)
        }
    }
}
