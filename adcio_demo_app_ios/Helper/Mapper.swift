//
//  Mapper.swift
//  adcio_demo_app_ios
//
//  Created by 10004 on 1/23/24.
//

import Foundation
import AdcioPlacement
import AdcioAnalytics

struct SuggestionMapper {
    static func map(from: [AdcioSuggestion]) -> [SuggestionEntity] {
        let products = from.map { $0.product }
        let options = from.map { $0.logOptions }
        
        let suggestions = zip(products, options).map { product, option in
            let productEntity = ProductEntity(id: product.id,
                                              name: product.name,
                                              image: product.image,
                                              price: product.price,
                                              seller: product.sellerId,
                                              isAd: true)
            
            let optionEntity = LogOptionEntity(requestId: option.requestId,
                                               adsetId: option.adsetId)
            
            return SuggestionEntity(product: productEntity,
                             option: optionEntity)
        }
        
        return suggestions
    }
}

struct LogOptionMapper {
    static func map(from: LogOptionEntity) -> AdcioLogOption {
        let option = AdcioLogOption(requestID: from.requestId,
                                    adsetID: from.adsetId)
        return option
    }
}
