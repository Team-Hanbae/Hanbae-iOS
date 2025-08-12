//
//  BannerCarouselView.swift
//  Hanbae
//
//  Created by Yunki on 8/12/25.
//

import SwiftUI

struct BannerCarouselView: View {
    @State private var currentPage: Int? = 0
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    if let surveyURL = URL(string: "https://forms.gle/BxXn9vp7qWVQ6eoQA") {
                        Link(destination: surveyURL) {
                            Image(.jeongakBanner)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .padding(.horizontal, 16)
                        .containerRelativeFrame(.horizontal)
                        .id(0)
                    }
                    
                    if let surveyURL = URL(string: "https://forms.gle/BxXn9vp7qWVQ6eoQA") {
                        Link(destination: surveyURL) {
                            Image(.jeongakBanner)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .padding(.horizontal, 16)
                        .containerRelativeFrame(.horizontal)
                        .id(1)
                    }
                }
                .scrollTargetLayout()
                
            }
            .scrollPosition(id: $currentPage, anchor: .leading)
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            
            Text("\(currentPage)")
        }
    }
}

#Preview {
    BannerCarouselView()
}
