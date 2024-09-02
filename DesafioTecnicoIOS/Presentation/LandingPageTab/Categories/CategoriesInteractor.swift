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

    let apiClient: FakeStoreApiClientProtocol

	init(presenter: CategoriesPresenterProtocol, apiClient: FakeStoreApiClientProtocol) {
		self.presenter = presenter
		self.apiClient = apiClient
	}
}

extension CategoriesInteractor: CategoriesInteractorProtocol {
    func fetchCategories() {
        Task { @MainActor in
            do {
                let categories = try await apiClient.getProductCategories()
                presenter.present(categories: categories)
            } catch {
                presenter.presentError(error: error as? URLError ?? URLError(.unknown))
            }
        }
    }
}
