//
//  DetailViewModel.swift
//  adcio_demo_app_ios
//
//  Created by 김민식 on 2024/01/24.
//

import Foundation
import OSLog
import AdcioAnalytics

final class DetailViewModel: ObservableObject {
    private let clientID: String = "f8f2e298-c168-4412-b82d-98fc5b4a114a"
    private var analyticsManager: AnalyticsProductManageable
    private(set) var suggestion: SuggestionEntity
    
    init(suggestion: SuggestionEntity) {
        self.analyticsManager = AnalyticsManager(clientID: clientID)
        self.suggestion = suggestion
    }
    
    func thumbnailImage() -> String {
        return suggestion.product.image
    }
    
    func seller() -> String {
        return suggestion.product.seller
    }
    
    func name() -> String {
        return suggestion.product.name
    }
    
    func price() -> Int {
        return suggestion.product.price
    }
    
    func identifier() -> String {
        return suggestion.product.id
    }
    
    func onView(with path: String) async {
        analyticsManager.onView(
            customerID: nil,
            productIDOnStore: suggestion.product.id,
            requestID: suggestion.option.requestId,
            adsetID: suggestion.option.adsetId,
            categoryIDOnStore: nil) { result in
                switch result {
                case .success(let isSuccess):
                    os_log("\(path) onView \(isSuccess) ✅")
                
                case .failure(let error):
                    os_log("\(path) onView : \(error) ❌")
                }
            }
    }
    
    func onAddToCart(cartID: String, productIDOnStore: String) async {
        analyticsManager.onAddToCart(
            cartID: cartID,
            customerID: nil,
            productIDOnStore: productIDOnStore,
            reqeustID: nil,
            adsetID: nil,
            categoryIdOnStore: nil,
            quantity: nil) { result in
                switch result {
                case .success(let isSuccess):
                    os_log("onAddToCart \(isSuccess) ✅")
                case .failure(let error):
                    os_log("onAddToCart : \(error) ❌")
                }
            }
    }
    
    func onPurchase(orderID: String, productIDOnStore: String, amount: Int) async {
        analyticsManager.onPurchase(
            orderID: orderID,
            customerID: nil,
            requestID: nil,
            adsetID: nil,
            categoryIDOnStore: nil,
            quantity: nil,
            productIDOnStore: productIDOnStore,
            amount: amount) { result in
                switch result {
                case .success(let isSuccess):
                    os_log("onPurchase \(isSuccess) ✅")
                case .failure(let error):
                    os_log("onPurchase : \(error) ❌")
                }
            }
    }
}
