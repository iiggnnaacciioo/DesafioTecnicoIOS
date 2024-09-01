//
//  LandingPageCellProtocol.swift
//  DesafioCodigoIOS
//
//  Created by Ignacio Schiefelbein on 31-08-24.
//

import UIKit

protocol LandingPageCellProtocol: UICollectionViewCell {
    func setup(title: String,
               price: String,
               imageURL: String,
               tapProductAction: @escaping() -> (),
               addProductAction: @escaping() -> ())
}
