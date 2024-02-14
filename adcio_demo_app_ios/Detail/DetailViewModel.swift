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
    
    func viewChanged(with path: String) async {
        analyticsManager.viewChanged(path: path, customerID: "corca0302", productIDOnStore: suggestion.product.id, title: suggestion.product.name) { result in
            switch result {
            case .success(let isSuccess):
                os_log("\(path) viewChanged \(isSuccess) ✅")
            
            case .failure(let error):
                os_log("\(path) viewChanged : \(error) ❌")
            }
        }
    }
    
    func addToCart(cartID: String, productIDOnStore: String) async {
        analyticsManager.addToCart(cartID: cartID,
                                   productIDOnStore: productIDOnStore) { result in
            switch result {
            case .success(let isSuccess):
                os_log("addToCart \(isSuccess) ✅")
            case .failure(let error):
                os_log("addToCart : \(error) ❌")
            }
        }
    }
    
    func productPurchased(orderID: String, productIDOnStore: String, amount: Int) async {
        analyticsManager.productPurchased(orderID: orderID,
                                          productIDOnStore: productIDOnStore,
                                          amount: amount) { result in
            switch result {
            case .success(let isSuccess):
                os_log("productPurchased \(isSuccess) ✅")
            case .failure(let error):
                os_log("productPurchased : \(error) ❌")
            }
        }
    }
}
