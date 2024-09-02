//
//CategoriesPresenter.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-08-31.
//Copyright © 2024 -. All rights reserved.
//

import Foundation

protocol CategoriesPresenterProtocol {
    func present(categories: [String])
    func presentError(error: URLError)
}

class CategoriesPresenter {
	weak var viewController: CategoriesViewControllerProtocol?

	init(viewController: CategoriesViewControllerProtocol?) {
		self.viewController = viewController
	}
}

extension CategoriesPresenter: CategoriesPresenterProtocol {
    func present(categories: [String]) {
        var categoryItems: [CategoryItemModel] = categories.map {
            CategoryItemModel(name: $0, path: $0)
        }
        categoryItems.insert(CategoryItemModel(name: "Todos", path: nil), at: 0)
        viewController?.show(categories: categoryItems)
    }
    
    func presentError(error: URLError) {
        viewController?.showError(message: error.localizedDescription)
    }
}
