//
//  ContentView.swift
//  adcio_demo_app_ios
//
//  Created by 유현명 on 11/8/23.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label(
                        title: {
                            Text("홈")
                                .font(.title)
                        },
                        icon: {
                            Image(systemName: "house.fill")
                                .font(.system(size: 22))
                        }
                    )
                }
            
            RecommendView()
                .tabItem {
                    Label(
                        title: {
                            Text("추천")
                                .font(.title)
                        },
                        icon: {
                            Image(systemName: "star.fill")
                                .font(.system(size: 22))
                        }
                    )
                }
            
            ChartView()
                .tabItem {
                    Label(
                        title: {
                            Text("목록")
                                .font(.title)
                        },
                        icon: {
                            Image(systemName: "list.bullet")
                                .font(.system(size: 22))
                        }
                    )
                }
        }
        .font(.headline)
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    ContentView()
}
