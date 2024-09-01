//
//CartView.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-09-01.
//Copyright © 2024 -. All rights reserved.
//

import UIKit

protocol CartViewProtocol: UIView {

}

protocol CartViewDelegate: AnyObject {
    
}

class CartView: UIView {
    //MARK: View Components

	weak var delegate: CartViewDelegate?

	init(delegate: CartViewDelegate) {
		self.delegate = delegate
		super.init(frame: .zero)
        setupView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    //MARK: Actions
    func setupView() {
        backgroundColor = .white
    }
}

extension CartView: CartViewProtocol {

}
