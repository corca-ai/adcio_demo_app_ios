//
//  adcio_demo_app_iosApp.swift
//  adcio_demo_app_ios
//
//  Created by 유현명 on 11/8/23.
//

import SwiftUI
import AdcioCore
@main
struct adcio_demo_app_iosApp: App {
    
    init() {
        AdcioCore.shared.initializeApp(clientId: "f8f2e298-c168-4412-b82d-98fc5b4a114a")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
