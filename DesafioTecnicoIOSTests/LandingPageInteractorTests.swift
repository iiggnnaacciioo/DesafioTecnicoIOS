//
//  LandingPageInteractorTests.swift
//  DesafioTecnicoIOSTests
//
//  Created by Ignacio Schiefelbein on 01-09-24.
//

import XCTest
@testable import DesafioTecnicoIOS

class MockLocalStorage: LocalStorageProtocol {
    private var cartItems: [ProductPurchaseIntent] = [
        ProductPurchaseIntent(quantity: 2, productId: 0),
        ProductPurchaseIntent(quantity: 5, productId: 1)
    ]
    
    var addedProductId: Int?
    
    func loadStoredCart() async -> [ProductPurchaseIntent] {
        return cartItems
    }
    
    func addOne(productId: Int) async {
        addedProductId = productId
    }
    
    func removeOne(productId: Int) async {

    }
    
    func delete(productId: Int) async {

    }
}

class MockFakeStoreApiClient: FakeStoreApiClientProtocol {
    var throwError: Bool = false
    
    private var products: [ProductResponse] = [
        ProductResponse(
            id: 1,
            title: "Product 1",
            price: 100.0,
            description: "Description of Product 1",
            category: "Electronics",
            image: "https://example.com/image1.jpg",
            rating: ProductResponse.Rating(rate: 4.5, count: 100)
        ),
        ProductResponse(
            id: 2,
            title: "Product 2",
            price: 200.0,
            description: "Description of Product 2",
            category: "Books",
            image: "https://example.com/image2.jpg",
            rating: ProductResponse.Rating(rate: 4.0, count: 50)
        ),
        ProductResponse(
            id: 3,
            title: "Product 3",
            price: 300.0,
            description: "Description of Product 3",
            category: "Electronics",
            image: "https://example.com/image3.jpg",
            rating: ProductResponse.Rating(rate: 4.8, count: 200)
        )
    ]
    
    private var categories: [String] = ["Electronics", "Books", "Clothing", "Home"]

    func getProducts() async throws -> [ProductResponse] {
        if throwError {
            throw URLError(.badServerResponse)
        }
        return products
    }
    
    func getProductsBy(category: String) async throws -> [ProductResponse] {
        if throwError {
            throw URLError(.badServerResponse)
        }
        return products.filter { $0.category == category }
    }
    
    func getProductCategories() async throws -> [String] {
        return categories
    }
    
    func getProductDetails(productId: Int) async throws -> ProductResponse {
        guard let product = products.first(where: { $0.id == productId }) else {
            throw URLError(URLError.fileDoesNotExist)
        }
        return product
    }
}

final class LandingPageInteractorTests: XCTestCase {
    class LandingPagePresenterSpy: LandingPagePresenterProtocol {
        var products: [ProductResponse]?
        
        var error: URLError?
        
        var purchaseIntents: [ProductPurchaseIntent]?
        
        func present(products: [ProductResponse]) {
            self.products = products
        }
        
        func present(error: URLError) {
            self.error = error
        }
        
        func present(purchaseIntents: [ProductPurchaseIntent]) {
            self.purchaseIntents = purchaseIntents
        }
    }


    var sut: LandingPageInteractor!
    
    var presenterSpy: LandingPagePresenterSpy!
    
    var mockApiClient: MockFakeStoreApiClient!
    
    var mockLocalStorage: MockLocalStorage!
    
    override func setUp() {
        presenterSpy = LandingPagePresenterSpy()
        mockApiClient = MockFakeStoreApiClient()
        mockLocalStorage = MockLocalStorage()
        sut = LandingPageInteractor(presenter: presenterSpy, apiClient: mockApiClient, localStorage: mockLocalStorage)
        super.setUp()
    }

    override func tearDown() {
        presenterSpy = nil
        mockApiClient = nil
        mockLocalStorage = nil
        sut = nil
        super.tearDown()
    }
    
    func testFetchProductsCategoryNilCallsPresentProductsOnPresenter() {
        let expectation = expectation(description: "wait for async")
        sut.fetchProducts(category: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5.0)
        XCTAssertEqual(presenterSpy.products?.count, 3)
    }
    
    func testFetchProductsByCategoryCallsPresentProductsOnPresenter() {
        let expectation = expectation(description: "wait for async")
        sut.fetchProducts(category: "Electronics")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5.0)
        XCTAssertEqual(presenterSpy.products?.count, 2)
    }
    
    func testFetchProductsErrorsCallsPresentPurchaseIntentsOnPresenter() {
        mockApiClient.throwError = true
        
        let expectation = expectation(description: "wait for async")
        sut.fetchProducts(category: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5.0)
        XCTAssertEqual(presenterSpy.error, URLError(URLError.badServerResponse))
    }
    
    func testAddToCartCallsPresentErrorOnPresenter() {
        mockApiClient.throwError = true
        
        let expectation = expectation(description: "wait for async")
        sut.addToCart(productId: 7)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5.0)
        XCTAssertEqual(presenterSpy.purchaseIntents?.count, 2)
        XCTAssertEqual(mockLocalStorage.addedProductId, 7)
    }
}
