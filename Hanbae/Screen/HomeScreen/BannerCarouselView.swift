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
    @State private var currentIndex: Int?
    @State private var expandedBanners: [[BannerInfo]] = []
    
    @State private var currentIndexSubject: PassthroughSubject<Int, Never> = .init()
    @State private var autoScrollSubscription: AnyCancellable?
    
    @State private var isViewAppear = false
    @State private var didInitialized = false
    
    var body: some View {
        let expandedBanners = self.expandedBanners.flatMap { $0 }
        
        ZStack(alignment: .bottomTrailing) {
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(expandedBanners.indices, id: \.self) { index in
                        if let surveyURL = URL(string: expandedBanners[index].urlString) {
                            Link(destination: surveyURL) {
                                Image(expandedBanners[index].imageResource)
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
        .onAppear {
            self.expandedBanners = [banners, banners, banners]
            if !didInitialized {
                self.currentIndex = banners.count
                didInitialized = true
            }
            isViewAppear = true
            
            autoScrollSubscription = currentIndexSubject
                .debounce(for: .seconds(5), scheduler: DispatchQueue.main)
                .sink { index in
                    let bannersCount = self.expandedBanners.flatMap({ $0 }).count
                    guard isViewAppear else { return }
                    guard let currentIndex else { return }
                    guard bannersCount > 1 else { return }
                    guard 0..<bannersCount - 1 ~= currentIndex else { return }
                    withAnimation {
                        self.currentIndex = index + 1
                    }
                }
            if let currentIndex {
                currentIndexSubject.send(currentIndex)
            }
        }
        .onDisappear {
            isViewAppear = false
            autoScrollSubscription?.cancel()
            autoScrollSubscription = nil
        }
        .onChange(of: currentIndex) { _, newIndex in
            guard let newIndex else { return }
            currentIndexSubject.send(newIndex)
            let bannerCount = banners.count
            if newIndex / bannerCount == 0 && newIndex % bannerCount == bannerCount - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.expandedBanners.removeLast()
                    self.expandedBanners.insert(banners, at: 0)
                    self.currentIndex = newIndex + bannerCount
                }
                return
            }
            
            if newIndex / bannerCount == 2 && newIndex % bannerCount == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.expandedBanners.removeFirst()
                    self.expandedBanners.append(banners)
                    self.currentIndex = newIndex - bannerCount
                }
                return
            }
        }
    }
    
    private var pagenation: some View {
        HStack(spacing: 4) {
            Text("\((currentIndex ?? 0) % banners.count + 1)")
                .foregroundStyle(.textDefault)
                .font(.pretendardRegular(fixedSize: 12))
            
            Rectangle()
                .frame(width: 1, height: 11)
                .foregroundStyle(.textTertiary)
            
            Text("\(banners.count)")
                .foregroundStyle(.textTertiary)
                .font(.pretendardRegular(fixedSize: 12))
            
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
