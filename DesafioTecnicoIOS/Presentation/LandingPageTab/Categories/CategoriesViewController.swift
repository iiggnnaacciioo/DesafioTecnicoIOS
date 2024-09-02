//
//CategoriesViewController.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-08-31.
//Copyright © 2024 -. All rights reserved.
//

import UIKit

protocol CategoriesViewControllerProtocol: AnyObject {
    func show(categories: [CategoryItemModel])
    func showError(message: String)
}

class CategoriesViewController: UIViewController {
	var categoriesView: CategoriesViewProtocol?

	var interactor: CategoriesInteractorProtocol?

    let filterWithCategoriesAction: (_ categoryPath: String?) -> ()

    let closeAction: () -> ()

    //MARK: Life cycle
    init(filterWithCategoriesAction: @escaping(_ categoryPath: String?) -> (), closeAction: @escaping() -> ()) {
        self.filterWithCategoriesAction = filterWithCategoriesAction
        self.closeAction = closeAction
		super.init(nibName: nil, bundle: nil)
		categoriesView = CategoriesView(delegate: self)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView() {
		super.loadView()
		view = categoriesView
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesView?.show(isLoading: true)
        interactor?.fetchCategories()
    }
}

extension CategoriesViewController: CategoriesViewControllerProtocol {
    func show(categories: [CategoryItemModel]) {
        categoriesView?.show(isLoading: false)
        categoriesView?.show(categories: categories)
    }
    
    func showError(message: String) {
        categoriesView?.show(isLoading: false)
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.overrideUserInterfaceStyle = .light
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            self?.close()
        }))
        present(alert, animated: true)
    }
}

extension CategoriesViewController: CategoriesViewDelegate {
    func close() {
        dismiss(animated: true)
        closeAction()
    }
    
    func filter(categoryPath: String?) {
        dismiss(animated: true)
        filterWithCategoriesAction(categoryPath)
    }
}
