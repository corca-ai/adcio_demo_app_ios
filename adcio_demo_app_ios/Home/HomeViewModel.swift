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
    
    func viewChanged(with path: String) async {
        analyticsManager.viewChanged(path: path) { result in
            switch result {
            case .success(let isSuccess):
                os_log("\(path) viewChanged \(isSuccess) ✅")
            case .failure(let error):
                os_log("\(path) viewChanged : \(error) ❌")
            }
        }
    }
    
    func productTapped(_ suggestion: SuggestionEntity) async {
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
            excludingProductIDs: ["1321"],
            categoryID: "2017",
            placementID: "5ae9907f-3cc2-4ed4-aaa4-4b20ac97f9f4",
            customerID: "corca0302",
            placementPositionX: 80,
            placementPositionY: 80,
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
