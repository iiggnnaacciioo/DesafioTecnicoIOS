//
//  FakeStoreApiRepository.swift
//  DesafioCodigoIOS
//
//  Created by Ignacio Schiefelbein on 29-08-24.
//

import Foundation

enum HTTPMethod {
    case GET
    
    var string: String {
        switch self {
        case .GET:
            return "GET"
        }
    }
}

protocol FakeStoreApiClientProtocol {
    func getProducts() async throws -> [ProductResponse]
    func getProductsBy(category: String) async throws -> [ProductResponse]
    func getProductCategories() async throws -> [String]
    func getProductDetails(productId: Int) async throws -> ProductResponse
}

struct FakeStoreApiClient: FakeStoreApiClientProtocol {
    let baseURL = "https://fakestoreapi.com/"
    
    func getProducts() async throws -> [ProductResponse] {
        do {
            return try await performRequest(buildRequest(method: .GET, path: "products"))
        } catch {
            throw error
        }
    }
    
    func getProductsBy(category: String) async throws -> [ProductResponse] {
        do {
            return try await performRequest(buildRequest(method: .GET, path: "products/category/\(category)"))
        } catch {
            throw error
        }
    }

    func getProductCategories() async throws -> [String] {
        do {
            return try await performRequest(buildRequest(method: .GET, path: "products/categories"))
        } catch {
            throw error
        }
    }
    
    func getProductDetails(productId: Int) async throws -> ProductResponse {
        do {
            return try await performRequest(buildRequest(method: .GET, path: "products/\(productId)"))
        } catch {
            throw error
        }
    }

    private func buildRequest(method: HTTPMethod, path: String) throws -> URLRequest {
        guard let path = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let url = URL(string: baseURL + path) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.string
        
        return request
    }
    
    private func performRequest<T: Codable>(_ request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            return try decode(data: data)
        } catch {
            throw error
        }
    }
    
    private func decode<T: Codable>(data: Data) throws -> T {
        //Product
        print("--> RESPONSE", String(decoding: data, as: UTF8.self))
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw error
        }
    }
}
