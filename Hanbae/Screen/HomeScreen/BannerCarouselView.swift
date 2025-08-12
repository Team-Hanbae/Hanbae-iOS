//
//  BannerCarouselView.swift
//  Hanbae
//
//  Created by Yunki on 8/12/25.
//

import SwiftUI

struct BannerCarouselView: View {
    let banners: [BannerInfo]
    
    @State private var currentPage: Int? = 0
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(banners.indices, id: \.self) { index in
                        if let surveyURL = URL(string: banners[index].urlString) {
                            Link(destination: surveyURL) {
                                Image(banners[index].imageResource)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            .padding(.horizontal, 16)
                            .containerRelativeFrame(.horizontal)
                            .id(index)
                        }
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
    BannerCarouselView(banners: [
        BannerInfo(imageResource: .jeongakBanner, urlString: "https://forms.gle/BxXn9vp7qWVQ6eoQA"),
        BannerInfo(imageResource: .surveyBanner, urlString: "https://forms.gle/BxXn9vp7qWVQ6eoQA"),
    ])
}
