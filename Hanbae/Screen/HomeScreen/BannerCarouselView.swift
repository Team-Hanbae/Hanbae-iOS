//
//  BannerCarouselView.swift
//  Hanbae
//
//  Created by Yunki on 8/12/25.
//

import SwiftUI
import Combine

struct BannerCarouselView: View {
    let banners: [BannerInfo]
    let currentIndex: Int!
    let onIndexChange: (Int) -> Void
    
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        let currentIndexBinding = Binding(
            get: { currentIndex },
            set: { newIndex in
                if let newIndex {
                    onIndexChange(newIndex)
                }
            }
        )
        
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
            .scrollPosition(id: currentIndexBinding, anchor: .center)
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            
            HStack(spacing: 4) {
                Text("\(currentIndex + 1)")
                    .foregroundStyle(.textDefault)
                    .font(.Caption1_R)
                
                Rectangle()
                    .frame(width: 1, height: 11)
                    .foregroundStyle(.textTertiary)
                
                Text("\(banners.count)")
                    .foregroundStyle(.textTertiary)
                    .font(.Caption1_R)
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 4, height: 8)
                    .foregroundStyle(.textDefault)
            }
            .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
            .background(.backgroundDefault.opacity(0.6))
            .cornerRadius(500)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 6, trailing: 24))
        }
        .frame(height: 120)
        .onReceive(timer) { _ in
            var newIndex = currentIndex + 1
            if newIndex >= banners.count { newIndex = 0 }
            withAnimation {
                onIndexChange(newIndex)
            }
        }
    }
}

#Preview {
    BannerCarouselView(banners: [
        BannerInfo(imageResource: .jeongakBanner, urlString: "https://forms.gle/BxXn9vp7qWVQ6eoQA"),
        BannerInfo(imageResource: .surveyBanner, urlString: "https://forms.gle/BxXn9vp7qWVQ6eoQA"),
    ], currentIndex: 0, onIndexChange: { i in })
}
