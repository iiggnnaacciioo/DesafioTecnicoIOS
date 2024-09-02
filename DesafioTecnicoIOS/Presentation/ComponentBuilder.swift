//
//  ComponentBuilder.swift
//  DesafioTecnicoIOS
//
//  Created by Ignacio Schiefelbein on 01-09-24.
//

import Foundation

struct ComponentBuilder {
    static func landingPageViewController() -> LandingPageViewController {
        let vc = LandingPageViewController()
        let presenter = LandingPagePresenter(viewController: vc)
        let localStorage = LocalStorage()
        let apiClient = FakeStoreApiClient()
        let interactor = LandingPageInteractor(
            presenter: presenter,
            apiClient: apiClient,
            localStorage: localStorage
        )
        vc.interactor = interactor
        return vc
    }
    
    static func cartViewController(closeAction: @escaping() -> ()) -> CartViewController {
        let vc = CartViewController(closeAction: closeAction)
        let presenter = CartPresenter(viewController: vc)
        let localStorage = LocalStorage()
        let apiClient = FakeStoreApiClient()
        let interactor = CartInteractor(presenter: presenter,
                                        apiClient: apiClient,
                                        localStorage: localStorage)
        vc.interactor = interactor
        return vc
    }
    
    static func categoriesViewController(filterWithCategoriesAction: @escaping(_ category: String?) -> (), closeAction: @escaping() -> ()) -> CategoriesViewController {
        let vc = CategoriesViewController(
            filterWithCategoriesAction: filterWithCategoriesAction,
            closeAction: closeAction
        )
        let presenter = CategoriesPresenter(viewController: vc)
        let apiClient = FakeStoreApiClient()
        let interactor = CategoriesInteractor(
            presenter: presenter,
            apiClient: apiClient
        )
        vc.interactor = interactor
        return vc
    }
    
    static func productDetailPageViewController(productId: Int, closeAction: @escaping() -> (), showToastAction: @escaping() -> ()) -> ProductDetailPageViewController {
        let vc = ProductDetailPageViewController(
            productId: productId,
            closeAction: closeAction,
            showToastAction: showToastAction
        )
        let presenter = ProductDetailPagePresenter(viewController: vc)
        let apiClient = FakeStoreApiClient()
        let localStorage = LocalStorage()
        let interactor = ProductDetailPageInteractor(
            presenter: presenter,
            apiClient: apiClient,
            localStorage: localStorage
        )
        vc.interactor = interactor
        return vc
    }
}
