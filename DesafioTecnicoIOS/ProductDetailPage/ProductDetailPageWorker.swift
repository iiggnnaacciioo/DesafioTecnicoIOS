//
//ProductDetailPageWorker.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-08-31.
//Copyright © 2024 -. All rights reserved.
//

import Foundation

protocol ProductDetailPageWorkerProtocol {
    func getProductDetails(productId: Int) async throws -> ProductResponse
}

class ProductDetailPageWorker: ProductDetailPageWorkerProtocol {
    let apiClient: FakeStoreApiClient
    
    init(apiClient: FakeStoreApiClient) {
        self.apiClient = apiClient
    }
    
    func getProductDetails(productId: Int) async throws -> ProductResponse {
        try await apiClient.getProductDetails(productId: productId)
    }
}
