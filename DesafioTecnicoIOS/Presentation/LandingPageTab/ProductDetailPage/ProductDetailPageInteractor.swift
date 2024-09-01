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
    func addToCart(productId: Int)
}

class ProductDetailPageInteractor {
	let presenter: ProductDetailPagePresenterProtocol

    let apiClient: FakeStoreApiClientProtocol

    let localStorage: LocalStorageProtocol

	init(presenter: ProductDetailPagePresenterProtocol, apiClient: FakeStoreApiClientProtocol,
         localStorage: LocalStorageProtocol) {
		self.presenter = presenter
        self.apiClient = apiClient
        self.localStorage = localStorage
	}
}

extension ProductDetailPageInteractor: ProductDetailPageInteractorProtocol {
    func fetchProductDetails(productId: Int) {
        Task { @MainActor in
            do {
                let productDetails = try await apiClient.getProductDetails(productId: productId)
                presenter.presentProductDetails(product: productDetails)
            } catch {
                presenter.presentProductDetails(error: error)
            }
        }
    }
    
    func addToCart(productId: Int) {
        Task {  @MainActor in
            await localStorage.addOne(productId: productId)
            presenter.presentAddedToCart()
        }
    }
}
