//
//  ChatBotView.swift
//  adcio_demo_app_ios
//
//  Created by 유현명 on 11/16/23.
//

import SwiftUI
import AdcioAgent
struct ChatBotView: View {
    
    @State private var productId: String = ""
    
    var body: some View {
        try? AdcioAgent(
            onClickProduct: { productId in
                self.productId = productId
            }
        )
        .background(
            NavigationLink(
                destination: ProductDetailView(
                    productValue: ProductEntity(
                        id: self.productId,
                        name: "",
                        image: "",
                        price: 0,
                        seller: "",
                        isAd: false
                    ),
                    logOptionValue: LogOptionEntity(requestId: "", adsetId: "")
                ),
                isActive: Binding<Bool>(
                    get: { self.productId != "" },
                    set: { _ in self.productId = "" }
                )
            ) {
                EmptyView()
            }.isDetailLink(false)
        )
    }
}
