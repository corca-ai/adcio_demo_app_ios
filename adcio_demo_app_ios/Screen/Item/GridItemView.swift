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
        productValue: ProductEntity
    ) {
        self.id = productValue.id
        self.name = productValue.name
        self.seller = productValue.seller
        self.price = productValue.price
        self.image = productValue.image
        self.isAd = productValue.isAd
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
                .foregroundColor(.black)
                .lineLimit(1)
                .multilineTextAlignment(.center)
                .frame(width: 120)
                .fixedSize(horizontal: false, vertical: true)
            Text(name)
                .font(.caption2)
                .foregroundColor(.black)
                .lineLimit(1)
                .multilineTextAlignment(.trailing)
                .frame(width: 150)
                .fixedSize(horizontal: false, vertical: true)
            HStack {
                Text("20%")
                    .foregroundColor(.black)
                    .font(.caption)
                Text("\(price)원")
                    .foregroundColor(.black)
                    .font(.caption)
            }
            .padding([.bottom], 23)
            .onAppear {
                isImageLoading = true
            }
        }
    }

}
