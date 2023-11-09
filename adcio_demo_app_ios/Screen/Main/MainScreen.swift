//
//  Main.swift
//  adcio_demo_app_ios
//
//  Created by 유현명 on 11/8/23.
//

import SwiftUI

struct MainView: View {
    var rows: [GridItem] = Array(repeating: .init(.fixed(50)), count: 2)
    var body: some View {
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
                VStack(alignment: .leading) {
                    Image("Banner")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Text("현명님을 위한 추천 상품")
                        .font(.subheadline)
                        .padding([.top], 3)
                        .padding([.leading, .bottom], 15)
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: rows, alignment: .center) {
                            ForEach((0...10), id: \.self) {_ in
                                VStack {
                                    Text("HIHELLO")
                                }
                            }
                        }
                    }.padding([.leading], 15)
                }
            }
        }
    }
}

#Preview {
    MainView()
}

