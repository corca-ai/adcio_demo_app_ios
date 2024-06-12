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
    private let clientID: String = "f8f2e298-c168-4412-b82d-98fc5b4a114a"
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
            excludingProductIDs: ["1001"],
            categoryID: "1",
            placementID: "67592c00-a230-4c31-902e-82ae4fe71866",
            customerID: "corca0302",
            fromAgent: false,
            birthYear: 2000,
            gender: .male, 
            filters: nil) { [weak self] result in
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
