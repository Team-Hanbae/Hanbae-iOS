//
//  HomeView.swift
//  Macro
//
//  Created by Yunki on 11/12/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.requestReview) private var requestReview
    @State private var viewModel: HomeViewModel
    
    private var router: Router
    private var appState: AppState
    
    init(viewModel: HomeViewModel, router: Router, appState: AppState) {
        self.viewModel = viewModel
        self.router = router
        self.appState = appState
    }
    
    var body: some View {
        ZStack {
            NavigationStack(path: Binding(
                get: { router.path }, set: { router.path = $0 }
            ))
            {
                VStack(spacing: 8) {
                    // MARK: - 상단 바
                    topBar
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // MARK: - 상단 배너
                            if let surveyURL = URL(string: "https://forms.gle/BxXn9vp7qWVQ6eoQA") {
                                Link(destination: surveyURL) {
                                    Image(.jeongakBanner)
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                }
                                .padding(.top, 8)
                                .padding(.horizontal, 16)
                            }
                            
                            // MARK: - 장단 리스트
                            VStack(spacing: 32) {
                                // MARK: - 커스텀 장단 리스트
                                customJangdanList
                                
                                
                                // MARK: - 빌트인 장단 리스트
                                builtinJangdanList
                            }
                            .padding(.bottom, 38.5)
                        }
                    }
                    .scrollIndicators(.hidden)
                    .ignoresSafeArea(edges: .bottom)
                    .navigationDestination(for: Route.self) { path in
                        router.view(for: path)
                    }
                }
            }
            
            Color.blink
                .ignoresSafeArea()
                .allowsHitTesting(false)
                .opacity(self.viewModel.state.isBlinking ? 1 : 0)
        }
    }
}

extension HomeView {
    private var topBar: some View {
        HStack {
            ZStack {
                Color.clear
                
                Image(.appLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 21)
            }
            .frame(width: 44, height: 44)
            .padding(EdgeInsets(top: 3, leading: 16, bottom: 8, trailing: 0))
            
            Spacer()
        }
        .frame(height: 54)
    }
    
    private var customJangdanList: some View {
        VStack(spacing: 8) {
            HStack {
                Text("내가 저장한 장단")
                    .font(.Title2_B)
                    .foregroundStyle(.textDefault)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 6)
                
                Spacer()
                
                Button {
                    self.router.push(.customJangdanList)
                } label: {
                    Text("더보기")
                        .font(.Callout_R)
                        .foregroundStyle(.textTertiary)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 6)
                        .frame(minWidth: 44, minHeight: 40)
                }
            }
            .padding(.horizontal, 16)
            
            if self.viewModel.state.customJangdanList.isEmpty {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.backgroundSheet)
                    .overlay {
                        Text("저장한 장단이 없어요")
                            .font(.Callout_R)
                            .foregroundStyle(.textQuaternary)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 84)
            } else {
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(self.viewModel.state.customJangdanList, id: \.name) { customJangdan in
                            Button {
                                self.router.push(.customJangdanPractice(jangdanName: customJangdan.name, jangdanType: customJangdan.type.name))
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .foregroundStyle(.backgroundSheet)
                                    
                                    Image(.customJangdanCardGradient)
                                        .resizable()
                                        .frame(width: 295, height: 295)
                                        .offset(y: 110)
                                    
                                    VStack(spacing: 2) {
                                        Text(customJangdan.name)
                                            .font(.Headline_SB)
                                            .foregroundStyle(.textDefault)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                            .frame(width: 156 - 32)
                                        
                                        Text(customJangdan.type.name)
                                            .font(.Subheadline_R)
                                            .foregroundStyle(.textTertiary)
                                    }
                                }
                                .frame(width: 156, height: 84)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                        
                        if self.viewModel.state.customJangdanList.count > 1 {
                            Button {
                                self.router.push(.customJangdanList)
                            } label: {
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(.backgroundSheet)
                                    .frame(width: 156, height: 84)
                                    .overlay {
                                        Text("더보기")
                                            .font(.Body_R)
                                            .foregroundStyle(.textSecondary)
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .frame(height: 84)
            }
        }
        .onAppear {
            self.viewModel.effect(action: .fetchCustomJangdanData)
        }
    }
    
    private var builtinJangdanList: some View {
        VStack(spacing: 8) {
            HStack {
                Text("바로 연습하기")
                    .font(.Title2_B)
                    .foregroundStyle(.textDefault)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 6)
                Spacer()
            }
            
            ForEach(Jangdan.allCases, id: \.self) { jangdan in
                Button {
                    self.router.push(.builtInJangdanPractice(jangdanName: jangdan.name))
                    self.appState.increaseEnteredJangdan()
                    if self.appState.numberOfEnteredJangdan % 100 == 0 {
                        self.requestReview()
                    }
                } label: {
                    HStack {
                        HStack(spacing: 20) {
                            jangdan.jangdanLogoImage
                                .resizable()
                                .foregroundStyle(.jangdanLogoPrimary)
                                .frame(width: 36, height: 36)
                                .padding(14)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(.jangdanLogoBackground)
                                }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(jangdan.name)
                                    .font(.Title3_SB)
                                    .foregroundStyle(.textDefault)
                                
                                Text(jangdan.bakInformation)
                                    .font(.Subheadline_R)
                                    .foregroundStyle(.textQuaternary)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20))
                            .foregroundStyle(.textTertiary)
                            .frame(width: 44, height: 44)
                    }
                    .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
                    .background(.backgroundSheet)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    HomeView(viewModel: DIContainer.shared.homeViewModel, router: DIContainer.shared.router, appState: DIContainer.shared.appState)
}
