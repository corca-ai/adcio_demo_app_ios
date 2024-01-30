//
//  ContentView.swift
//  adcio_demo_app_ios
//
//  Created by 유현명 on 11/8/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            TabView {
                NavigationStack {
                    HomeView(height: geometry.frame(in: .named("grid")).size.height)
                }
                .tabItem { Label("홈", systemImage: "house.fill") }
                
                Text("추천 화면")
                    .tabItem { Label("추천", systemImage: "star.fill") }
                
                Text("목록 화면")
                    .tabItem { Label("목록", systemImage: "list.bullet") }
            }
            .coordinateSpace(name: "grid")
        }
    }
}

#Preview {
    ContentView()
}
