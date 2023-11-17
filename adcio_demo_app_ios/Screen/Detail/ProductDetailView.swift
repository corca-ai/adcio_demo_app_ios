//
//  ProductDetailView.swift
//  adcio_demo_app_ios
//
//  Created by 유현명 on 11/13/23.
//

import SwiftUI

struct ProductDetailView: View {
    
    let id: String
    var name: String
    let seller: String
    let price: Int
    let image: String
    let isAd: Bool
    
    @State var isImageLoading: Bool = true
    
    init(productValue: ProductEntity) {
        let jsonData = fetchJsonData()

        if !productValue.id.isEmpty {
            guard !productValue.name.isEmpty else {
                guard let clickedProduct = jsonData.first(where: { $0.id == productValue.id }) else {
                    fatalError("No value found for that productId: \(productValue.id)")
                }

                self.id = clickedProduct.id
                self.name = clickedProduct.name
                self.seller = clickedProduct.seller
                self.price = clickedProduct.price
                self.image = clickedProduct.image
                self.isAd = clickedProduct.isAd

                return
            }
        }

        self.id = productValue.id
        self.name = productValue.name
        self.seller = productValue.seller
        self.price = productValue.price
        self.image = productValue.image
        self.isAd = productValue.isAd
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    AsyncImage(url: URL(string: image)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
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
                    VStack(alignment: .leading) {
                        Text(seller)
                            .foregroundColor(.gray)
                            .font(.system(size: 13))
                        Text(name)
                            .foregroundColor(.black)
                            .font(.system(size: 19))
                            .padding(.top, 5)
                        HStack {
                            Text("\(price)원")
                                .foregroundColor(.black)
                                .font(.system(size: 19))
                            Spacer()
                            Text("20%")
                                .foregroundColor(.black)
                                .font(.system(size: 19))
                                .padding(.trailing, -5)
                            Text("SALE")
                                .foregroundColor(.black)
                                .font(.system(size: 12))
                                .padding(.top, 4)
                                .padding(.trailing, 10)
                        }
                    }
                    .padding(.leading, 15)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Divider()
                        .background(.black)
                        .frame(height: 3)
                        .padding(.horizontal, 15)
                    
                    Spacer()
                        .frame(height: 15)
                    
                    HStack {
                        Text("전 상품 무료배송")
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                        
                        Spacer()
                        
                        Text("1일 이내 출발 확률 97%")
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                    }
                    .padding(.horizontal, 15)
                    
                    Spacer().frame(height: 10)
                }
                .navigationBarTitle(name, displayMode: .inline)
                .navigationBarItems(
                    trailing:
                        HStack {
                            Image(systemName: "cart.fill")
                                .foregroundColor(.black)
                                .onTapGesture {
                                    // Analytics Add To Cart
                                }
                        }
                    )
            }
            HStack {
                Spacer()
                Image(systemName: "heart")
                    .foregroundColor(.black)
                Spacer()
                Button(action: {
                    // Analaytics.onPurchase
                }) {
                    Text("구매하기")
                        .frame(width: 250, height: 42)
                        .background(Color.black) // Change the color as needed
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
                .padding(.trailing, 10)
            }
            Spacer()
        }
    }
}
