//
//  HomeViewModel.swift
//  adcio_demo_app_ios
//
//  Created by 10004 on 1/23/24.
//

import Foundation
import OSLog

import AdcioAnalytics
import AdcioPlacement

final class HomeViewModel: ObservableObject {
    private let clientID: String = "76dc12fa-5a73-4c90-bea5-d6578f9bc606"
    private var analyticsManager: AnalyticsViewManageable
    private var placementManager: PlacementManageable
    private var impressable: Bool = false
    
    @Published var suggestions: [SuggestionEntity] = []
    
    init() {
        self.analyticsManager = AnalyticsManager(clientID: clientID)
        self.placementManager = PlacementManager()
    }
    
    func onClick(_ suggestion: SuggestionEntity) async {
        guard suggestion.product.isAd else { return }
        
        let option = LogOptionMapper.map(from: suggestion.option)
        
        analyticsManager.onClick(option: option, customerID: nil) { result in
            switch result {
            case .success(let isSuccess):
                os_log("onClick ✅ \(isSuccess) ")
            case .failure(let error):
                os_log("onClick ❌ : \(error) ")
            }
        }
    }
    
    @MainActor
    func onImpression(with option: LogOptionEntity) {
        guard impressable else { return }
        
        let option = LogOptionMapper.map(from: option)
        
        analyticsManager.onImpression(option: option, customerID: nil, productIDOnStore: nil) { result in
            switch result {
            case .success(let isSuccess):
                os_log("onImpression ✅ \(isSuccess) ")
            case .failure(let error):
                os_log("onImpression ❌ : \(error) ")
            }
        }
    }
    
    @MainActor
    func createAdvertisementProducts() {
        placementManager.createAdvertisementProducts(
            clientID: clientID,
            excludingProductIDs: nil,
            categoryID: "2179",
            placementID: "5ae9907f-3cc2-4ed4-aaa4-4b20ac97f9f4",
            customerID: "corca0302",
            fromAgent: false,
            birthYear: 2000,
            gender: .male, 
            filters: [
                "price_excluding_tax": Filter(not: 53636),
                "product_code": Filter(contains: "KY")
            ]) { [weak self] result in
                switch result {
                case .success(let suggestions):
                    self?.suggestions = SuggestionMapper.map(from: suggestions)
                    self?.impressable = true
                    os_log("createAdvertisementProducts ✅")
                    
                case .failure(let error):
                    os_log("createAdvertisementProducts ❌ : \(error)")
                }
            }
    }
}
