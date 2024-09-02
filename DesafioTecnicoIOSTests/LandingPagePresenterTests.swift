//
//  LandingPagePresenterTests.swift
//  DesafioTecnicoIOSTests
//
//  Created by Ignacio Schiefelbein on 01-09-24.
//

import XCTest
@testable import DesafioTecnicoIOS

final class LandingPagePresenterTests: XCTestCase {
    
    class LandingPageViewControllerSpy: NSObject, LandingPageViewControllerProtocol {
        var highlightedItem: ProductModel?
        var items: [ProductModel] = []
        var errorMessage: String?
        var updateCartItemQuantity: String?
        
        func show(items: [ProductModel], highlightedItem: ProductModel) {
            self.items = items
            self.highlightedItem = highlightedItem
        }
        
        func showError(message: String) {
            errorMessage = message
        }
        
        func updateCartItem(quantity: String?) {
            updateCartItemQuantity = quantity
        }
    }

    var sut: LandingPagePresenter!
    
    var viewControllerSpy: LandingPageViewControllerSpy!

    override func setUp() {
        viewControllerSpy = LandingPageViewControllerSpy()
        sut = LandingPagePresenter(viewController: viewControllerSpy)
        super.setUp()
    }

    override func tearDown() {
        viewControllerSpy = nil
        sut = nil
        super.tearDown()
    }
    
    func testPresentProductsShowsItemsOnViewController() {
        sut.present(products: [])
        XCTAssertEqual(viewControllerSpy.errorMessage, "No se encontraron productos", "Wrong error message")
    }
    
    func testPresentEmptyProductsShowsErrorOnViewController() {
        sut.present(products: [
            ProductResponse(id: 0, title: "", price: 1.00, description: "", category: "", image: "", rating: ProductResponse.Rating(rate: 5.0, count: 1)),
            ProductResponse(id: 1, title: "Product A", price: 3.00, description: "", category: "", image: "", rating: ProductResponse.Rating(rate: 3.0, count: 3))
        ])
        XCTAssertEqual(viewControllerSpy.items.count, 1, "Only 1 item should remain in items array")
        XCTAssertEqual(viewControllerSpy.highlightedItem?.title, "Product A", "Wrong item was highlighted")
    }
    
    func testPresentPurchaseIntentsPassesQuantityStringToViewController() {
        sut.present(purchaseIntents: [
            ProductPurchaseIntent(quantity: 1, productId: 12),
            ProductPurchaseIntent(quantity: 2, productId: 9),
            ProductPurchaseIntent(quantity: 1000, productId: 2)
        ])
        XCTAssertEqual(viewControllerSpy.updateCartItemQuantity, "1003")
    }
    
    func testPresentEmptyPurchaseIntentsPassesNilQuantityToViewController() {
        sut.present(purchaseIntents: [])
        XCTAssertNil(viewControllerSpy.updateCartItemQuantity)
    }
    
    func testPresentURLErrorPassesMessageToViewController() {
        sut.present(error: URLError(.badURL))
        XCTAssertEqual(viewControllerSpy.errorMessage, URLError(.badURL).localizedDescription)
    }
}
