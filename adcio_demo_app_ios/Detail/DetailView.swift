//
//  DetailView.swift
//  adcio_demo_app_ios
//
//  Created by 김민식 on 2024/01/24.
//

import SwiftUI

struct DetailView: View {
    private var viewModel: DetailViewModel
    
    init(suggestion: SuggestionEntity) {
        self.viewModel = DetailViewModel(suggestion: suggestion)
    }
    
    var body: some View {
        Content(viewModel: viewModel)
            .task {
                await viewModel.onView(with: "Detail")
            }
    }
}

// MARK: - Content
extension DetailView {
    struct Content: View {
        let viewModel: DetailViewModel
        
        var body: some View {
            NavigationStack {
                VStack {
                    ScrollView {
                        Thumbnail(imageURL: viewModel.thumbnailImage())
                        
                        Description(seller: viewModel.seller(),
                                    name: viewModel.name(),
                                    price: viewModel.price())
                    }
                    
                    Purchase(viewModel: viewModel)
                }
            }
            .navigationTitle(viewModel.name())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await viewModel.onAddToCart(cartID: "0",
                                                      productIDOnStore: viewModel.identifier())
                        }
                    } label: {
                        Image(systemName: "cart.fill")
                    }
                }
            }
        }
    }
}

// MARK: - Thumbnail
extension DetailView {
    struct Thumbnail: View {
        let imageURL: String
        
        var body: some View {
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                
            }
            .frame(height: 200)
        }
    }
}

// MARK: - Description
extension DetailView {
    struct Description: View {
        let seller: String
        let name: String
        let price: Int
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(seller)
                    .foregroundColor(.gray)
                    .font(.system(size: 13))
                    .padding(.horizontal)
                    .padding(.top)
                
                Text(name)
                    .foregroundColor(.black)
                    .font(.system(size: 19))
                    .padding(.horizontal)
                
                HStack(spacing: 0) {
                    Text("\(price)원")
                        .foregroundColor(.black)
                        .font(.system(size: 19))
                    
                    Spacer()
                    
                    Text("20%")
                        .foregroundColor(.black)
                        .font(.system(size: 19))
                    
                    Text("SALE")
                        .foregroundColor(.black)
                        .font(.system(size: 12))
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            Divider()
                .background(.black)
                .frame(height: 3)
            
            Spacer()
            
            HStack {
                Text("전 상품 무료배송")
                    .foregroundColor(.black)
                    .font(.system(size: 12))
                
                Spacer()
                
                Text("1일 이내 출발 확률 97%")
                    .foregroundColor(.black)
                    .font(.system(size: 12))
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Purchase
extension DetailView {
    struct Purchase: View {
        let viewModel: DetailViewModel
        
        var body: some View {
            Button {
                Task {
                    await viewModel.onPurchase(orderID: "123123",
                                                     productIDOnStore: viewModel.identifier(),
                                                     amount: viewModel.price())
                }
            } label: {
                Text("구매하기")
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
    }
}
