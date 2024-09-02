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

class ProductDetailPageViewController: UIViewController, Toast {
    var toastView: ToastView?
    
	var productDetailPageView: ProductDetailPageViewProtocol?

	var interactor: ProductDetailPageInteractorProtocol?
    
    let productId: Int
    
    let closeAction: () -> ()
    
    let showToastAction: () -> ()

    //MARK: Life cycle
    init(productId: Int, closeAction: @escaping() -> (), showToastAction: @escaping() -> ()) {
        self.productId = productId
        self.closeAction = closeAction
        self.showToastAction = showToastAction
		super.init(nibName: nil, bundle: nil)
		productDetailPageView = ProductDetailPageView(delegate: self)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView() {
		super.loadView()
        self.edgesForExtendedLayout = []
		view = productDetailPageView
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchProductDetails(productId: productId)
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
        showToastAction()
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
