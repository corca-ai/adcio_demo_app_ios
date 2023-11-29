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
    @State private var logOptions: [LogOptionEntity] = []
    
    var body: some View {
        NavigationView {
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
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
                            AsyncImage(url: URL(string: "https://picsum.photos/500/300")) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxHeight: 300)
                                } else {
                                    Text("Image not available")
                                }
                            }
                            
                            Text("민채님을 위한 추천 상품")
                                .font(.subheadline)
                                .padding([.top], 3)
                                .padding([.leading, .bottom], 15)
                            
                            ScrollView(.horizontal) {
                                LazyHGrid(rows: [GridItem(.flexible(minimum: 170), spacing: 8), GridItem(.flexible(minimum: 170), spacing: 8)], spacing: 2) {
                                    ForEach(products, id: \.id) { product in
                                        NavigationLink(destination: ProductDetailView(productValue: product, logOptionValue: correspondingLogOption(product) ?? LogOptionEntity(requestId: "", adsetId: ""))) {
                                                GridItemView(productValue: product)
                                                .frame(width: 150)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .onAppear {
                        let jsonData = fetchJsonData()
                        
                        fetchSuggestData { productList in
                            products.append(contentsOf: jsonData)
                        } logOption: { logOptionList in
                            logOptions = logOptionList
                        }
                    }
                }
                ZStack {
                    NavigationLink(destination: ChatBotView()) {
                        Circle()
                            .foregroundColor(Color(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image("agent_talk")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                                    .padding(.bottom, 2)
                            )
                            .padding([.trailing, .bottom], 20)
                    }
                }
            }
            .onAppear {
                
                try? AdcioAnalytics.shared.onPageView(
                    path: "Main",
                    onFailure: { Error in
                        dump("Analytics pageview call is failed")
                    }
                )
                
                fetchSuggestData { productList in
                    self.products = productList
                } logOption: { logOptionList in
                    self.logOptions = logOptionList
                }
                
                
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
    
    private func correspondingLogOption(_ product: ProductEntity) -> LogOptionEntity? {
        return logOptions.first { $0.requestId == product.id }
    }
}
