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

}

class CartPresenter {
	weak var viewController: CartViewControllerProtocol?

	init(viewController: CartViewControllerProtocol?) {
		self.viewController = viewController
	}
}

extension CartPresenter: CartPresenterProtocol {

}