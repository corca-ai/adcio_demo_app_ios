//
//  ChartView.swift
//  adcio_demo_app_ios
//
//  Created by 유현명 on 11/8/23.
//

import SwiftUI
import AdcioAnalytics

struct ChartView: View {
    
    var body: some View {
        VStack {
            Text("Chart")
        }
        .padding()
        .onAppear{
            try? AdcioAnalytics.shared.onPageView(
                path: "ProductDetail",
                onFailure: { Error in
                    dump("Analytics pageview call is failed")
                }
            )
        }
    }
}

#Preview {
    ChartView()
}
