//
//  GridItemView.swift
//  adcio_demo_app_ios
//
//  Created by 유현명 on 11/9/23.
//

import SwiftUI
import UIKit

struct GridItemView: View {
    
    let id: String
    let name: String
    let seller: String
    let price: Int
    let image: String
    let isAd: Bool
    
    @State private var isImageLoading = true
    
    init(
        id: String,
        name: String,
        seller: String,
        price: Int,
        image: String,
        isAd: Bool
    ) {
        self.id = id
        self.name = name
        self.seller = seller
        self.price = price
        self.image = image
        self.isAd = isAd
    }
    
    var body: some View {
        VStack {
            ZStack {
                AsyncImage(url: URL(string: image)) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 140)
                            .overlay(
                                isAd ? Text("AD")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(Color.gray)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .offset(x: -20) : nil,
                                alignment: .bottomTrailing
                            )
                    } else if phase.error != nil {
                        Text("Image not available")
                    } else {
                        if isImageLoading {
                            ProgressView()
                                .onAppear {
                                    isImageLoading = false
                                }
                        }
                    }
                }
            }

            Text(seller)
                .font(.caption)
                .lineLimit(1)
                .multilineTextAlignment(.center)
                .frame(width: 120)
                .fixedSize(horizontal: false, vertical: true)
            Text(name)
                .font(.caption2)
                .lineLimit(1)
                .multilineTextAlignment(.trailing)
                .frame(width: 150)
                .fixedSize(horizontal: false, vertical: true)
            HStack {
                Text("20%")
                    .font(.caption)
                Text("\(price)원")
                    .font(.caption)
            }
            .padding([.bottom], 23)
            .onAppear {
                isImageLoading = true
            }
        }
    }

}
