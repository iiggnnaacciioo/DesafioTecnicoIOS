//
//CartViewController.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-09-01.
//Copyright © 2024 -. All rights reserved.
//

import UIKit

protocol CartViewControllerProtocol: AnyObject {

}

class CartViewController: UIViewController {
	var cartView: CartViewProtocol?

	var interactor: CartInteractorProtocol?
    
    let closeAction: () -> ()

	init(closeAction: @escaping() -> ()) {
        self.closeAction = closeAction
		super.init(nibName: nil, bundle: nil)
		cartView = CartView(delegate: self)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView() {
		super.loadView()
		view = cartView
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "Home"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            closeAction()
        }
    }
    
    static func instance(closeAction: @escaping() -> ()) -> CartViewController {
        let vc = CartViewController(closeAction: closeAction)
        let presenter = CartPresenter(viewController: vc)
        let interactor = CartInteractor(presenter: presenter,
                                        worker: CartWorker())
        vc.interactor = interactor
        return vc
    }
}

extension CartViewController: CartViewControllerProtocol {

}

extension CartViewController: CartViewDelegate {
    func goBack() {
        closeAction()
        navigationController?.popViewController(animated: true)
    }
}
