//
//LandingPageWorker.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-08-29.
//Copyright © 2024 -. All rights reserved.
//

import Foundation

protocol LandingPageWorkerProtocol {
    func getProducts() async throws -> [ProductResponse]
    func getProductsBy(category: String) async throws -> [ProductResponse]
}

class LandingPageWorker: LandingPageWorkerProtocol {
    let apiClient: FakeStoreApiClient
    
    init(apiClient: FakeStoreApiClient) {
        self.apiClient = apiClient
    }
    
    func getProducts() async throws -> [ProductResponse] {
        try await apiClient.getProducts()
    }
    
    func getProductsBy(category: String) async throws -> [ProductResponse] {
        try await apiClient.getProductsBy(category: category)
    }
}
