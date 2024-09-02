//
//  LandingPageCellProtocol.swift
//  DesafioCodigoIOS
//
//  Created by Ignacio Schiefelbein on 31-08-24.
//

import UIKit

protocol LandingPageCellProtocol: UICollectionViewCell {
    
    var addButton: UIButton { get }

    func setup(title: String,
               price: String,
               imageURL: String,
               tapProductAction: @escaping() -> (),
               addProductAction: @escaping() -> ())
}

extension LandingPageCellProtocol {
    func disableAddButtonTemporarily() {
        addButton.tintColor = .lightGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [weak self] in
            self?.addButton.tintColor = .systemBlue
        })
    }
}
