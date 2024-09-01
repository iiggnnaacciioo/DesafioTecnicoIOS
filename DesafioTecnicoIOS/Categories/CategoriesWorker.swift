//
//CategoriesWorker.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-08-31.
//Copyright © 2024 -. All rights reserved.
//

import Foundation

protocol CategoriesWorkerProtocol {
    func getProductCategories() async throws -> [String]
}

class CategoriesWorker: CategoriesWorkerProtocol {
    let apiClient: FakeStoreApiClient
    
    init(apiClient: FakeStoreApiClient) {
        self.apiClient = apiClient
    }
    
    func getProductCategories() async throws -> [String] {
        try await apiClient.getProductCategories()
    }
}
