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
    @State private var currentIndex: Int? = 0
    
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    @State private var isViewAppear = false
    
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
            .scrollPosition(id: $currentIndex, anchor: .center)
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            
            pagenation
        }
        .frame(height: 120)
        .onReceive(timer) { _ in
            guard isViewAppear else { return }
            withAnimation {
                if let currentIndex {
                    if currentIndex >= banners.count - 1 {
                        self.currentIndex = 0
                    } else {
                        self.currentIndex = currentIndex + 1
                    }
                }
            }
        }
        .onAppear {
            isViewAppear = true
        }
        .onDisappear {
            isViewAppear = false
        }
    }
    
    private var pagenation: some View {
        HStack(spacing: 4) {
            Text("\((currentIndex ?? 0) + 1)")
                .foregroundStyle(.textDefault)
                .font(.pretendardRegular(size: 12))
            
            Rectangle()
                .frame(width: 1, height: 11)
                .foregroundStyle(.textTertiary)
            
            Text("\(banners.count)")
                .foregroundStyle(.textTertiary)
                .font(.pretendardRegular(size: 12))
            
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
}

#Preview {
    BannerCarouselView(banners: [
        BannerInfo(imageResource: .jeongakBanner, urlString: "https://forms.gle/BxXn9vp7qWVQ6eoQA"),
        BannerInfo(imageResource: .surveyBanner, urlString: "https://forms.gle/BxXn9vp7qWVQ6eoQA"),
    ])
}
