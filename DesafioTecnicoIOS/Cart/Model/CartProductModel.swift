//
//  CartProductModel.swift
//  DesafioTecnicoIOS
//
//  Created by Ignacio Schiefelbein on 01-09-24.
//

import Foundation

struct CartProductModel: Hashable {
    let id: Int
    let title: String
    let formattedPrice: String
    let imageURL: String
    var quantity: Int

    init(product: ProductResponse, quantity: Int) {
        self.id = product.id
        self.title = product.title
        self.quantity = quantity
        self.imageURL = product.image
        self.formattedPrice = CurrencyHelper.formatDollarToCLPesos(amount: product.price, exchangeRate: 900)
    }
}
