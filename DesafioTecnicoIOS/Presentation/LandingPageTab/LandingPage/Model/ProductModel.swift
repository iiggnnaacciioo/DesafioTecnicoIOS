//
//  ProductModel.swift
//  DesafioCodigoIOS
//
//  Created by Ignacio Schiefelbein on 29-08-24.
//

import Foundation

struct ProductModel: Hashable {
    let uuid: String = UUID().uuidString
    let id: Int
    let title: String
    let description: String
    let formattedPrice: String
    let rating: Double
    let highlightScore: Double
    let imageURL: String

    init(product: ProductResponse) {
        self.id = product.id
        self.title = product.title
        self.description = product.description
        self.highlightScore = product.rating.rate * Double(product.rating.count)
        self.rating = product.rating.rate
        self.imageURL = product.image
        self.formattedPrice = CurrencyHelper.formatDollarToCLP(amount: product.price, exchangeRate: CurrencyHelper.dollarToCLPRate)
    }
}
