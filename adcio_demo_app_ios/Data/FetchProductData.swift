//
//  FetchData.swift
//  adcio_demo_app_ios
//
//  Created by 유현명 on 11/9/23.
//

import Foundation
import AdcioPlacement
import AdcioAnalytics
import SwiftUI

func fetchJsonData() -> [ProductEntity] {
    var productValue: [ProductEntity] = []
    
    let fileNm: String = "Product"
    let extensionType = "json"
    
    guard let fileLocation = Bundle.main.url(forResource: fileNm, withExtension: extensionType) else { return [] }
    
    do {
        let jsonData = try Data(contentsOf: fileLocation)
        productValue = try JSONDecoder().decode([ProductEntity].self, from: jsonData)
    } catch {
        dump("Json Parsing Error")
    }
    
    return productValue
}

func fetchSuggestData(completion: @escaping ([AdcioSuggestion]) -> Void) {
    
    var suggestValue: [AdcioSuggestion] = []
    
    try? AdcioPlacement.shared.adcioCreateSuggestion(
        placementId: "67592c00-a230-4c31-902e-82ae4fe71866",
        onSuccess: { adcioSuggestionRawData in
            let suggestionData = adcioSuggestionRawData.suggestions
            for index in 0..<suggestionData.count {
                suggestValue.append(suggestionData[index])
            }
            completion(suggestValue)
        },
        onFailure: { error in
            dump("Placement call is failed")
            completion([])
        }
    )
}



