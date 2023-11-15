//
//  ChartView.swift
//  adcio_demo_app_ios
//
//  Created by 유현명 on 11/8/23.
//

import SwiftUI
import AdcioAnalytics

struct ChartView: View {
    
    init() {
        try? AdcioAnalytics.shared.onPageView(
            path: "Chart",
            onFailure: { Error in
                dump("Analytics pageview call is failed")
            }
        )
    }
    
    var body: some View {
        VStack {
            Text("Chart")
        }
        .padding()
    }
}

#Preview {
    ChartView()
}
