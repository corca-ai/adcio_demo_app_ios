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
    
    @State private var products: [ProductEntity] = []
    
    init() {
        try? AdcioAnalytics.shared.onPageView(
            path: "Main",
            onFailure: { Error in
                dump("Analytics pageview call is failed")
            }
        )
    }
    
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
                                ForEach(products, id: \.id) { product in
                                    let productValue = ProductEntity(
                                        id: product.id,
                                        name: product.name,
                                        image: product.image,
                                        price: product.price,
                                        seller: product.seller,
                                        isAd: product.isAd
                                    )
                                    NavigationLink(destination: ProductDetailView(productValue: productValue)) {
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
                products = fetchJsonData() + fetchSuggestData()
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}
