//
//CartWorker.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-09-01.
//Copyright © 2024 -. All rights reserved.
//

import Foundation

protocol CartWorkerProtocol {
	func getSomething(onSuccess: @escaping ()  -> (), onError: @escaping () -> ())
}

class CartWorker: CartWorkerProtocol {
	func getSomething(onSuccess: @escaping() -> (), onError: @escaping() -> ()) {

	}
}