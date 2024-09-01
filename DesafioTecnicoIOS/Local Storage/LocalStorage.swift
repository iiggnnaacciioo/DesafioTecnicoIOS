//
//  LocalStorage.swift
//  DesafioTecnicoIOS
//
//  Created by Ignacio Schiefelbein on 01-09-24.
//

import Foundation

protocol LocalStorageProtocol {
    func loadStoredCart() async -> [ProductPurchaseIntent]
    func addOne(productId: Int) async
    func removeOne(productId: Int) async
    func delete(productId: Int) async
}

actor LocalStorage: LocalStorageProtocol {
    let purchaseIntentKey = "productPurchaseIntent"
    
    func loadStoredCart() async -> [ProductPurchaseIntent] {
        guard let savedData = UserDefaults.standard.data(forKey: purchaseIntentKey),
              let productPurchaseIntents = try? JSONDecoder().decode([ProductPurchaseIntent].self, from: savedData) else {
            return []
        }
        return productPurchaseIntents
    }

    func addOne(productId: Int) async {
        var storedPurchaseIntents = await loadStoredCart()

        if let existingIndex = storedPurchaseIntents.firstIndex(where: {
            $0.productId == productId
        }) {
            let newQuantity = storedPurchaseIntents[existingIndex].quantity + 1
            storedPurchaseIntents[existingIndex] = ProductPurchaseIntent(quantity: newQuantity, productId: productId)
        } else {
            let newProductPurchaseIntent: ProductPurchaseIntent = ProductPurchaseIntent(quantity: 1, productId: productId)
            storedPurchaseIntents.append(newProductPurchaseIntent)
        }
        
        await store(productPurchaseIntents: storedPurchaseIntents)
    }
    
    func removeOne(productId: Int) async {
        var storedPurchaseIntents = await loadStoredCart()

        guard let existingIndex = storedPurchaseIntents.firstIndex(where: {
            $0.productId == productId
        }) else {
            return
        }
                
        let newQuantity = storedPurchaseIntents[existingIndex].quantity - 1
        storedPurchaseIntents[existingIndex] = ProductPurchaseIntent(quantity: newQuantity, productId: productId)
        
        await store(productPurchaseIntents: storedPurchaseIntents)
    }
    
    func delete(productId: Int) async {
        var storedPurchaseIntents = await loadStoredCart()
        storedPurchaseIntents.removeAll(where: {
            $0.productId == productId
        })

        await store(productPurchaseIntents: storedPurchaseIntents)
    }
    
    private func store(productPurchaseIntents: [ProductPurchaseIntent]) async {
        if let data = try? JSONEncoder().encode(productPurchaseIntents) {
            UserDefaults.standard.set(data, forKey: purchaseIntentKey)
        }
    }
}
