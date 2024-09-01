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

}

class CartInteractor {
	let presenter: CartPresenterProtocol

	let worker: CartWorkerProtocol

	init(presenter: CartPresenterProtocol, worker: CartWorkerProtocol) {
		self.presenter = presenter
		self.worker = worker
	}
}

extension CartInteractor: CartInteractorProtocol {

}