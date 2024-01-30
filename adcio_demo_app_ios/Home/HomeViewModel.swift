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
    
    @Published var suggestions: [SuggestionEntity] = []
    
    init() {
        self.analyticsManager = AnalyticsManager(clientID: clientID)
        self.placementManager = PlacementManager()
        DispatchQueue.main.async {
            self.createSuggestion()
        }
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
    
    func productImpressed(with option: LogOptionEntity) async {
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
        placementManager.adcioCreateSuggestion(placementID: "67592c00-a230-4c31-902e-82ae4fe71866",
                                               customerID: "corca0302",
                                               placementPositionX: 80,
                                               placementPositionY: 80,
                                               fromAgent: false,
                                               birthYear: 2000,
                                               gender: .male,
                                               area: "Korea",
                                               categoryIdOnStore: nil) { [weak self] result in
            switch result {
            case .success(let suggestions):
                self?.suggestions = SuggestionMapper.map(from: suggestions)
                os_log("createSuggestion ✅")
                
            case .failure(let error):
                os_log("createSuggestion ❌ : \(error)")
            }
        }
    }
}
