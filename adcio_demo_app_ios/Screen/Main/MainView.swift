//
//  Main.swift
//  adcio_demo_app_ios
//
//  Created by 유현명 on 11/8/23.
//

import SwiftUI
import AdcioPlacement
import AdcioAnalytics

struct MainView: View {
    
    @State private var suggestions: [AdcioSuggestion] = []
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image("corca_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 30)
                        .padding([.top, .leading], 5)
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .frame(width: 30, height: 30)
                        .padding([.top, .trailing], 10)
                }
                .padding([.bottom], 5)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        Image("Banner")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        Text("민채님을 위한 추천 상품")
                            .font(.subheadline)
                            .padding([.top], 3)
                            .padding([.leading, .bottom], 15)
                        
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: [GridItem(.flexible(minimum: 170), spacing: 8), GridItem(.flexible(minimum: 170), spacing: 8)], spacing: 2) {
                                ForEach(suggestions, id: \.product.id) { suggestion in
                                    let productValue = ProductEntity(
                                        id: suggestion.product.id,
                                        name: suggestion.product.name,
                                        image: suggestion.product.image,
                                        price: suggestion.product.price,
                                        seller: suggestion.product.description,
                                        isAd: suggestion.product.includeInRecommendation
                                    )
                                    let logOptionValue = AdcioLogOption(
                                        requestId: suggestion.logOptions.requestId,
                                        adsetId: suggestion.logOptions.adsetId
                                    )
                                    NavigationLink(destination: ProductDetailView(productValue: productValue, logOptionValue: logOptionValue)) {
                                        GridItemView(productValue: productValue)
                                            .frame(width: 150)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                
                try? AdcioAnalytics.shared.onPageView(
                    path: "ProductDetail",
                    onFailure: { Error in
                        dump("Analytics pageview call is failed")
                    }
                )
                
                fetchSuggestData { suggestionValue in
                    suggestions = suggestionValue
                }
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}
