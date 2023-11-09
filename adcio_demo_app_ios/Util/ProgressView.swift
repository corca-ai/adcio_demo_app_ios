//
//  ProgressView.swift
//  adcio_demo_app_ios
//
//  Created by 유현명 on 11/9/23.
//

import SwiftUI

struct CustomProgressView: View {
    @State private var progress: Double = 0.0
    let totalProgress: Double

    var body: some View {
        VStack {
            Text("Loading...")
                .font(.headline)
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 200, height: 20)
                    .foregroundColor(.gray)
                Rectangle()
                    .frame(width: 200 * progress, height: 20)
                    .foregroundColor(.blue)
                    .animation(.linear(duration: 0.5))
            }
            Text("\(Int(progress * 100))%")
        }
        .onAppear {
            withAnimation {
                progress = totalProgress
            }
        }
    }
}
