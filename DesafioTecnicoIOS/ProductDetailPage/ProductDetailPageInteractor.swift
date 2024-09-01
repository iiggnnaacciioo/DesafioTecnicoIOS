//
//ProductDetailPageInteractor.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-08-31.
//Copyright © 2024 -. All rights reserved.
//

import Foundation

protocol ProductDetailPageInteractorProtocol {
    func fetchProductDetails(productId: Int)
}

class ProductDetailPageInteractor {
	let presenter: ProductDetailPagePresenterProtocol

	let worker: ProductDetailPageWorkerProtocol

	init(presenter: ProductDetailPagePresenterProtocol, worker: ProductDetailPageWorkerProtocol) {
		self.presenter = presenter
		self.worker = worker
	}
}

extension ProductDetailPageInteractor: ProductDetailPageInteractorProtocol {
    func fetchProductDetails(productId: Int) {
        Task { @MainActor in
            do {
                let productDetails = try await worker.getProductDetails(productId: productId)
                presenter.presentProductDetails(product: productDetails)
            } catch {
                presenter.presentProductDetails(error: error)
            }
        }
    }
}
