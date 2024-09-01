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
    func addToCart(productId: Int)
}

class LandingPageInteractor {
	let presenter: LandingPagePresenterProtocol

	let worker: LandingPageWorkerProtocol

	init(presenter: LandingPagePresenterProtocol, worker: LandingPageWorkerProtocol) {
		self.presenter = presenter
		self.worker = worker
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
        print("addToCart productId: \(productId)")
    }
}
