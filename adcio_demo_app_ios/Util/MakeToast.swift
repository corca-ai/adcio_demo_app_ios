//
//  MakeToast.swift
//  adcio_demo_app_ios
//
//  Created by 유현명 on 11/10/23.
//

import SwiftUI

struct ToastView<Content>: View where Content: View {
    @Binding var isVisible: Bool
    let hideAfter: Double
    let content: Content

    init(isVisible: Binding<Bool>, hideAfter: Double, @ViewBuilder content: () -> Content) {
        self._isVisible = isVisible
        self.hideAfter = hideAfter
        self.content = content()
    }

    var body: some View {
        content
            .opacity(isVisible ? 1 : 0)
            .animation(.easeInOut(duration: 0.5))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + hideAfter) {
                    isVisible = false
                }
            }
    }
}
