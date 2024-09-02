//
//LandingPageViewController.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-08-29.
//Copyright © 2024 -. All rights reserved.
//

import UIKit

protocol LandingPageViewControllerProtocol: AnyObject {
    func show(items: [ProductModel], highlightedItem: ProductModel)
    func showError(message: String)
    func updateCartItem(quantity: String?)
}

class LandingPageViewController: UIViewController, Toast {
    var toastView: ToastView?
    
    var blurView: UIView?

	var landingPageView: LandingPageViewProtocol?

	var interactor: LandingPageInteractorProtocol?

    //MARK: Life cycle
	init() {
		super.init(nibName: nil, bundle: nil)
		landingPageView = LandingPageView(delegate: self)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView() {
		super.loadView()
		view = landingPageView
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProducts(category: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        parent?.title = "My super App"
        parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(showCategories))
        navigationController?.navigationBar.prefersLargeTitles = true
        interactor?.loadPurchaseIntents()
    }

    private func fetchProducts(category: String?) {
        landingPageView?.show(isLoading: true)
        interactor?.fetchProducts(category: category)
    }
    
    static var instance: LandingPageViewController {
        let vc = LandingPageViewController()
        let presenter = LandingPagePresenter(viewController: vc)
        let localStorage = LocalStorage()
        let apiClient = FakeStoreApiClient()
        let interactor = LandingPageInteractor(presenter: presenter, apiClient: apiClient, localStorage: localStorage)
        vc.interactor = interactor
        return vc
    }
    
    @objc func showCategories() {
        let vc = CategoriesViewController.instance { [weak self] category in
            self?.blur(on: false)
            self?.fetchProducts(category: category)
        } closeAction: { [weak self] in
            self?.blur(on: false)
        }
        
        guard let navigationController = navigationController else {
            return
        }

        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        navigationController.present(vc, animated: true)
        blur(on: true)
    }
    
    private func blur(on: Bool) {
        guard let navigationController = navigationController else {
            return
        }

        if on {
            let bView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.light))
            bView.frame = navigationController.view.bounds
            navigationController.view.addSubview(bView)
            blurView = bView
        } else {
            blurView?.removeFromSuperview()
            blurView = nil
        }
    }
    
    private func showAddToCartToast(delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.showToast(message: "Producto añadido al carro", parentView: self?.view)
        }
    }
}

//MARK: LandingPageViewControllerProtocol
extension LandingPageViewController: LandingPageViewControllerProtocol {
    func show(items: [ProductModel], highlightedItem: ProductModel) {
        landingPageView?.show(isLoading: false)
        landingPageView?.show(highlightedItem: highlightedItem, items: items)
    }
    
    func showError(message: String) {
        landingPageView?.show(isLoading: false)
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.overrideUserInterfaceStyle = .light
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    func updateCartItem(quantity: String?) {
        guard let tabBarController,
              let cartItem = tabBarController.tabBar.items?.first(where: {
                    $0.tag == 1
                }) else {
            return
        }
        
        cartItem.badgeValue = quantity
    }
}

//MARK: LandingPageViewDelegate
extension LandingPageViewController: LandingPageViewDelegate {
    func showProductDetail(selectedProductId: Int) {
        let vc = ProductDetailPageViewController.instance(productId: selectedProductId) { [weak self] in
            self?.interactor?.loadPurchaseIntents()
        } showToastAction: { [weak self] in
            self?.showAddToCartToast(delay: 0.4)
        }
        guard let navigationController = navigationController else {
            return
        }
        vc.view.frame = navigationController.view.bounds
        navigationController.addChild(vc)
        navigationController.view.addSubview(vc.view)
        vc.didMove(toParent: navigationController)
    }
    
    func addToCart(selectedProductId: Int) {
        interactor?.addToCart(productId: selectedProductId)
        showAddToCartToast(delay: 0)
    }
}
