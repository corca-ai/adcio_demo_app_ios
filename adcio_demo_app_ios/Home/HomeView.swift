//
//  HomeView.swift
//  adcio_demo_app_ios
//
//  Created by 10004 on 1/23/24.
//

import SwiftUI
import AdcioAgent

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    private let height: CGFloat
    
    init(height: CGFloat) {
        self.height = height
    }
    
    var body: some View {
        Content(viewModel: viewModel, height: height)
            .onAppear {
                viewModel.createAdvertisementProducts()
            }
    }
}

// MARK: - Content
extension HomeView {
    struct Content: View {
        private let columns: [GridItem] = Array(repeating: GridItem(), count: 2)
        private let height: CGFloat
        
        @ObservedObject var viewModel: HomeViewModel
        @State private var viewHeight: CGFloat = 0
        
        init(viewModel: HomeViewModel, height: CGFloat) {
            self.viewModel = viewModel
            self.height = height
        }
        
        var body: some View {
            VStack {
                NavigationTitle()
                
                ZStack(alignment: .bottomTrailing) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            Banner()
                            
                            Text("추천 상품")
                                .padding(.horizontal)
                                .font(.title3)
                            
                            LazyVGrid(columns: columns, spacing: 15) {
                                ForEach(viewModel.suggestions, id: \.self) { suggestion in
                                    NavigationLink {
                                        DetailView(suggestion: suggestion)
                                    } label: {
                                        ProductGrid(suggestion,
                                                    rootViewHeight: height,
                                                    viewModel: viewModel)
                                    }
                                    .simultaneousGesture(TapGesture().onEnded{
                                        viewModel.onImpression(with: suggestion.option)
                                    })
                                }
                            }
                        }
                    }
                    
                    NavigationLink {
                        AgentView()
                    } label: {
                        Circle()
                            .foregroundColor(Color(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image("agent_talk")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                                    .padding(.bottom, 2)
                            )
                            .padding([.trailing, .bottom], 20)
                    }
                }
            }
        }
    }
}

// MARK: - Navigation Title
extension HomeView {
    struct NavigationTitle: View {
        var body: some View {
            HStack {
                Image("corca_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 30)
                
                Spacer()
                
                Image(systemName: "magnifyingglass")
                    .frame(width: 30, height: 30)
            }
            .padding([.horizontal, .vertical], 5)
        }
    }
}

// MARK: - Banner
extension HomeView {
    struct Banner: View {
        var body: some View {
            Image("Banner")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

// MARK: - Product Grid
extension HomeView {
    struct ProductGrid: View {
        @State private var isImageLoading = true
        @State private var midY: CGFloat = 0
        @ObservedObject var viewModel: HomeViewModel
        
        private let suggestion: SuggestionEntity
        private let rootViewHeight: CGFloat
        
        init(_ suggestion: SuggestionEntity, rootViewHeight: CGFloat, viewModel: HomeViewModel) {
            self.suggestion = suggestion
            self.rootViewHeight = rootViewHeight
            self.viewModel = viewModel
        }
        
        var body: some View {
            VStack {
                ZStack {
                    AsyncImage(url: URL(string: suggestion.product.image)) { phase in
                        if let image = phase.image {
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 140, height: 140)
                                .overlay(
                                    suggestion.product.isAd ? Text("AD")
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                        .padding(5)
                                        .background(Color.gray)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .offset(x: -20) :
                                        nil,
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
                
                Text(suggestion.product.seller)
                    .font(.caption)
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
                    .frame(width: 120)
                    .fixedSize(horizontal: false, vertical: true)
                Text(suggestion.product.name)
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
                    Text("\(suggestion.product.price)원")
                        .foregroundColor(.black)
                        .font(.caption)
                }
                .padding([.bottom], 40)
                .onAppear {
                    isImageLoading = true
                }
            }
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onChange(of: geometry.frame(in: .named("grid"))) { value in
                            if value.midY < self.rootViewHeight {
                                if self.midY != 0 {
                                    viewModel.onImpression(with: suggestion.option)
                                } else {
                                    self.midY = value.midY
                                }
                            }
                        }
                }
            )
            
        }
    }
}

#Preview {
    HomeView(height: 0)
}
