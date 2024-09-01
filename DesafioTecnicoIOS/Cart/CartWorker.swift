//
//CartWorker.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-09-01.
//Copyright © 2024 -. All rights reserved.
//

import Foundation

protocol CartWorkerProtocol {
    func getProductDetails(productId: Int) async throws -> ProductResponse
}

class CartWorker: CartWorkerProtocol {
    let apiClient: FakeStoreApiClient
    
    init(apiClient: FakeStoreApiClient) {
        self.apiClient = apiClient
    }
    
    func getProductDetails(productId: Int) async throws -> ProductResponse {
        try await apiClient.getProductDetails(productId: productId)
    }
}
