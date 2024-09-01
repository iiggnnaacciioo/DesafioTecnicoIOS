//
//  ProductResponse.swift
//  DesafioCodigoIOS
//
//  Created by Ignacio Schiefelbein on 29-08-24.
//

import Foundation

struct ProductResponse: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
        
    struct Rating: Codable {
        let rate: Double
        let count: Int
    }
}
