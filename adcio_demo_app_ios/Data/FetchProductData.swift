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

// TODO: Json 값 파라미터 escape로 받아오기
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

func fetchSuggestData(
    suggestion: @escaping ([ProductEntity]) -> Void,
    logOption: (([LogOptionEntity]) -> Void)? = nil
) {

    var productValue: [ProductEntity] = []
    var logOptionValue: [LogOptionEntity] = []

    try? AdcioPlacement.shared.adcioCreateSuggestion(
        placementId: "67592c00-a230-4c31-902e-82ae4fe71866"
    ) { AdcioSuggestionRawData in
        let suggestionData = AdcioSuggestionRawData.suggestions

        for index in 0..<suggestionData.count {
            let suggestedProduct = ProductEntity(
                id: suggestionData[index].product.id,
                name: suggestionData[index].product.name,
                image: suggestionData[index].product.image,
                price: suggestionData[index].product.price,
                seller: suggestionData[index].product.description,
                isAd: true
            )
            productValue.append(suggestedProduct)
        }
        suggestion(productValue)

        if let logOption = logOption {
            for index in 0..<suggestionData.count {
                let logOptions = LogOptionEntity(
                    requestId: suggestionData[index].logOptions.requestId,
                    adsetId: suggestionData[index].logOptions.adsetId
                )
                logOptionValue.append(logOptions)
            }
            logOption(logOptionValue)
        }
    } onFailure: { Error in
        @State var showToast = true
        ToastView(isVisible: $showToast, hideAfter: 2) {
            Text("Placement call is failed")
                .padding()
                .background(Color.black)
                .foregroundColor(Color.white)
                .cornerRadius(10)
        }
        dump("Placement call is failed")
        suggestion([])
        logOption?([]) 
    }
}
