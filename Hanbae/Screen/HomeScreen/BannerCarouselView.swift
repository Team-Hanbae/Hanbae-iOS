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
    let currentIndex: Int
    let onIndexChange: (Int) -> Void
    
    @State private var internalCurrentIndex: Int?
    
    @State private var timerSubscription: AnyCancellable?
    
    private let repeatBannerCount = 21
    
    private var extendedBanners: [BannerInfo] {
        Array(repeating: banners, count: repeatBannerCount).flatMap{ $0 }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(extendedBanners.indices, id: \.self) { index in
                        if let surveyURL = URL(string: extendedBanners[index].urlString) {
                            Link(destination: surveyURL) {
                                Image(extendedBanners[index].imageResource)
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
            .scrollPosition(id: $internalCurrentIndex, anchor: .center)
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .onChange(of: internalCurrentIndex) { _, newValue in
                if let newValue {
                    onIndexChange(newValue % banners.count)
                }
            }
            
            pagenation
        }
        .frame(height: 120)
        .onAppear {
            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                internalCurrentIndex = repeatBannerCount / 2 * banners.count + currentIndex
            }
            
            self.timerSubscription = Timer.publish(every: 5, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    withAnimation {
                        if let index = internalCurrentIndex {
                            if index >= extendedBanners.count - 1 {
                                self.internalCurrentIndex = repeatBannerCount / 2 * banners.count + currentIndex
                            } else {
                                self.internalCurrentIndex = index + 1
                            }
                        }
                    }
                }
        }
        .onDisappear {
            self.timerSubscription?.cancel()
            self.timerSubscription = nil
        }
    }
    
    private var pagenation: some View {
        HStack(spacing: 4) {
            Text("\(realCurrentIndex + 1)")
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
    
    private var realCurrentIndex: Int {
        guard let internalCurrentIndex else { return 0 }
        return internalCurrentIndex % banners.count
    }
}

#Preview {
    BannerCarouselView(banners: [
        BannerInfo(imageResource: .jeongakBanner, urlString: "https://forms.gle/BxXn9vp7qWVQ6eoQA"),
        BannerInfo(imageResource: .surveyBanner, urlString: "https://forms.gle/BxXn9vp7qWVQ6eoQA"),
    ], currentIndex: 0, onIndexChange: { i in })
}
