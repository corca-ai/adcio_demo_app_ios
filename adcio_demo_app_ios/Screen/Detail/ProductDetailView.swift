//
//  ProductDetailView.swift
//  adcio_demo_app_ios
//
//  Created by 유현명 on 11/13/23.
//

import SwiftUI
import AdcioAnalytics

struct ProductDetailView: View {
    
    let id: String
    var name: String
    let seller: String
    let price: Int
    let image: String
    let isAd: Bool
    
    @State var isImageLoading: Bool = true
  
    let logOption: LogOptionEntity
    
    init(
        productValue: ProductEntity,
        logOptionValue: LogOptionEntity
    ) {
        self.id = productValue.id
        self.name = productValue.name
        self.seller = productValue.seller
        self.price = productValue.price
        self.image = productValue.image
        self.isAd = productValue.isAd
        self.logOption = logOptionValue
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
                                    try? AdcioAnalytics.shared.onAddToCart(
                                        cartId: "0",
                                        productIdOnStore: id,
                                        onFailure: { Error in
                                            @State var showToast = true
                                            ToastView(isVisible: $showToast, hideAfter: 2) {
                                                Text("Analytics add to cart call is failed")
                                                    .padding()
                                                    .background(Color.black)
                                                    .foregroundColor(Color.white)
                                                    .cornerRadius(10)
                                            }
                                            dump("Analytics add to cart call is failed")
                                        }
                                    )
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
                    try? AdcioAnalytics.shared.onPurchase(
                        orderId: "123123",
                        productIdOnStore: id,
                        amount: self.price,
                        onFailure: { Error in
                            @State var showToast = true
                            ToastView(isVisible: $showToast, hideAfter: 2) {
                                Text("Analytics purchase call is failed")
                                    .padding()
                                    .background(Color.black)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(10)
                            }
                            dump("Analytics purchase call is failed")
                        }
                    )
                }) {
                    Text("구매하기")
                        .frame(width: 250, height: 42)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
                .padding(.trailing, 10)
            }
            Spacer()
        }
        .onAppear{
            try? AdcioAnalytics.shared.onClick(
                option: AdcioLogOption(
                    requestId: logOption.requestId,
                    adsetId: logOption.adsetId
                ),
                onFailure: { Error in
                    dump("Analytics click call is failed")
                })
            
            try? AdcioAnalytics.shared.onPageView(
                path: "ProductDetail",
                onFailure: { Error in
                    dump("Analytics pageview call is failed")
                }
            )
        }
    }
}
