//
//CategoriesInteractor.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-08-31.
//Copyright © 2024 -. All rights reserved.
//

import Foundation

protocol CategoriesInteractorProtocol {
    func fetchCategories()
}

class CategoriesInteractor {
	let presenter: CategoriesPresenterProtocol

	let worker: CategoriesWorkerProtocol

	init(presenter: CategoriesPresenterProtocol, worker: CategoriesWorkerProtocol) {
		self.presenter = presenter
		self.worker = worker
	}
}

extension CategoriesInteractor: CategoriesInteractorProtocol {
    func fetchCategories() {
        Task { @MainActor in
            do {
                let categories = try await worker.getProductCategories()
                presenter.present(categories: categories)
            } catch {
                
            }
        }
    }
}
