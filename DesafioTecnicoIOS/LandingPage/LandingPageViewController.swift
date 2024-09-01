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
}

class LandingPageViewController: UIViewController {
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
    }

    private func fetchProducts(category: String?) {
        landingPageView?.show(isLoading: true)
        interactor?.fetchProducts(category: category)
    }
    
    static var instance: LandingPageViewController {
        let vc = LandingPageViewController()
        let presenter = LandingPagePresenter(viewController: vc)
        let worker = LandingPageWorker(apiClient: FakeStoreApiClient())
        let interactor = LandingPageInteractor(presenter: presenter, worker: worker)
        vc.interactor = interactor
        return vc
    }
    
    @objc func showCategories() {
        let vc = CategoriesViewController.instance { [weak self] category in
            self?.landingPageView?.blur(on: false)
            self?.fetchProducts(category: category)
        } closeAction: { [weak self] in
            self?.landingPageView?.blur(on: false)
        }
        
        guard let navigationController = navigationController else {
            return
        }

        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        navigationController.present(vc, animated: true)
        landingPageView?.blur(on: true)
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
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive))
        present(alert, animated: true)
    }
}

//MARK: LandingPageViewDelegate
extension LandingPageViewController: LandingPageViewDelegate {
    func show(selectedProductId: Int) {
        let vc = ProductDetailPageViewController.instance(productId: selectedProductId) {
            
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
    }
}
