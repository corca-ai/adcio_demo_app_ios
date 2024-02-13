//
//  AgentView.swift
//  adcio_demo_app_ios
//
//  Created by 김민식 on 2024/01/24.
//

import SwiftUI
import AdcioAgent

struct AgentView: View {
    @State private var productID: String = ""
    
    var body: some View {
        AdcioAgent(clientID: "f8f2e298-c168-4412-b82d-98fc5b4a114a") {
            productID in
                self.productID = productID
        }
        .background(
            NavigationLink(
                destination: DetailView(
                    suggestion:
                        SuggestionEntity(product: 
                                            ProductEntity(id: self.productID,
                                                          name: "",
                                                          image: "",
                                                          price: 0,
                                                          seller: "",
                                                          isAd: false),
                                         option:
                                            LogOptionEntity(requestId: "",
                                                            adsetId: "")
                                        )
                ),
                isActive: Binding<Bool>(
                    get: { self.productID != "" },
                    set: { _ in self.productID = "" }
                )
            ) {
                EmptyView()
            }
            .isDetailLink(false)
        )
    }
}

#Preview {
    AgentView()
}
