//
//ProductDetailPageViewController.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-08-31.
//Copyright © 2024 -. All rights reserved.
//

import UIKit

protocol ProductDetailPageViewControllerProtocol: AnyObject {
    func showProductDetails(product: ProductModel)
    func showProductDetails(errorMessage: String)
    func showAddedToCart()
}

class ProductDetailPageViewController: UIViewController {
	var productDetailPageView: ProductDetailPageViewProtocol?

	var interactor: ProductDetailPageInteractorProtocol?
    
    let productId: Int
    
    let closeAction: () -> ()

    //MARK: Life cycle
    init(productId: Int, closeAction: @escaping() -> ()) {
        self.productId = productId
        self.closeAction = closeAction
		super.init(nibName: nil, bundle: nil)
		productDetailPageView = ProductDetailPageView(delegate: self)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView() {
		super.loadView()
		view = productDetailPageView
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchProductDetails(productId: productId)
    }
    
    static func instance(productId: Int, closeAction: @escaping() -> ()) -> ProductDetailPageViewController {
        let vc = ProductDetailPageViewController(productId: productId, closeAction: closeAction)
        let presenter = ProductDetailPagePresenter(viewController: vc)
        let apiClient = FakeStoreApiClient()
        let localStorage = LocalStorage()
        let interactor = ProductDetailPageInteractor(presenter: presenter, apiClient: apiClient, localStorage: localStorage)
        vc.interactor = interactor
        return vc
    }
}

extension ProductDetailPageViewController: ProductDetailPageViewControllerProtocol {
    func showProductDetails(product: ProductModel) {
        productDetailPageView?.show(product: product)
    }
    
    func showProductDetails(errorMessage: String) {
        let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
        alert.overrideUserInterfaceStyle = .light
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            self?.close()
        }))
        present(alert, animated: true)
    }
    
    func showAddedToCart() {
        productDetailPageView?.animateOutro()
    }
}

extension ProductDetailPageViewController: ProductDetailPageViewDelegate {
    func close() {
        closeAction()
        removeFromParent()
        productDetailPageView?.removeFromSuperview()
        didMove(toParent: nil)
    }
    
    func addProductToCart() {
        interactor?.addToCart(productId: productId)
    }
}
