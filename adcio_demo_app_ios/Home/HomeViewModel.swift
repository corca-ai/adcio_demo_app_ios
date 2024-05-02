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
    
    func productTapped(_ suggestion: SuggestionEntity) async {
        guard suggestion.product.isAd else { return }
        
        let option = LogOptionMapper.map(from: suggestion.option)
        
        analyticsManager.productTapped(option: option) { result in
            switch result {
            case .success(let isSuccess):
                os_log("productTapped ✅ \(isSuccess) ")
            case .failure(let error):
                os_log("productTapped ❌ : \(error) ")
            }
        }
    }
    
    @MainActor
    func productImpressed(with option: LogOptionEntity) {
        guard impressable else { return }
        
        let optionEntity = LogOptionMapper.map(from: option)
        
        analyticsManager.productImpressed(option: optionEntity) { result in
            switch result {
            case .success(let isSuccess):
                os_log("productImpressed ✅ \(isSuccess) ")
            case .failure(let error):
                os_log("productImpressed ❌ : \(error) ")
            }
        }
    }
    
    @MainActor
    func createSuggestion() {
        placementManager.adcioCreateSuggestion(
            clientID: clientID,
            excludingProductIDs: ["1001"],
            categoryID: "1",
            placementID: "67592c00-a230-4c31-902e-82ae4fe71866",
            customerID: "corca0302",
            fromAgent: false,
            birthYear: 2000,
            gender: .male,
            area: "Korea") { [weak self] result in
                switch result {
                case .success(let suggestions):
                    self?.suggestions = SuggestionMapper.map(from: suggestions)
                    self?.impressable = true
                    os_log("createSuggestion ✅")
                    
                case .failure(let error):
                    os_log("createSuggestion ❌ : \(error)")
                }
            }
    }
}
