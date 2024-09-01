//
//ProductDetailPagePresenter.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-08-31.
//Copyright © 2024 -. All rights reserved.
//

import Foundation

protocol ProductDetailPagePresenterProtocol {
    func presentProductDetails(product: ProductResponse)
    func presentProductDetails(error: Error)
}

class ProductDetailPagePresenter {
	weak var viewController: ProductDetailPageViewControllerProtocol?

	init(viewController: ProductDetailPageViewControllerProtocol?) {
		self.viewController = viewController
	}
}

extension ProductDetailPagePresenter: ProductDetailPagePresenterProtocol {
    func presentProductDetails(product: ProductResponse) {
        let item = ProductModel(product: product)
        viewController?.showProductDetails(product: item)
    }
    
    func presentProductDetails(error: Error) {
        viewController?.showProductDetails(errorMessage: error.localizedDescription)
    }
}
