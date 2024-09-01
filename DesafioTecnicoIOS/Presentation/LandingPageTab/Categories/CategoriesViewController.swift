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
        interactor?.fetchCategories()
    }
    
    static func instance(filterWithCategoriesAction: @escaping(_ category: String?) -> (), closeAction: @escaping() -> ()) -> CategoriesViewController {
        let vc = CategoriesViewController(filterWithCategoriesAction: filterWithCategoriesAction, closeAction: closeAction)
        let presenter = CategoriesPresenter(viewController: vc)
        let apiClient = FakeStoreApiClient()
        let interactor = CategoriesInteractor(presenter: presenter, apiClient: apiClient)
        vc.interactor = interactor
        return vc
    }
}

extension CategoriesViewController: CategoriesViewControllerProtocol {
    func show(categories: [CategoryItemModel]) {
        categoriesView?.show(categories: categories)
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
