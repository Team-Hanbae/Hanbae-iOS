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
                VStack(spacing: 0) {
                    // MARK: - 상단 바
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
                    
                    ScrollView {
                        // MARK: - 기본 장단 목록
                        VStack(spacing: 0) {
                            if let surveyURL = URL(string: "https://forms.gle/uZCyBishXSHAwfTHA") {
                                Link(destination: surveyURL) {
                                    Image(.surveyBanner)
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                }
                                .padding(.vertical, 24)
                            }
                            
                            VStack {
                                ForEach(self.appState.selectedInstrument.defaultJangdans, id: \.self) { jangdan in
                                    Button(jangdan.name) {
                                        self.router.push(.builtInJangdanPractice(jangdanName: jangdan.name))
                                        self.appState.increaseEnteredJangdan()
                                        if self.appState.numberOfEnteredJangdan % 100 == 0 {
                                            self.requestReview()
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, 38.5)
                        }
                    }
                    .scrollIndicators(.hidden)
                    .ignoresSafeArea(edges: .bottom)
                    .padding(.horizontal, 16)
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

#Preview {
    HomeView(viewModel: DIContainer.shared.homeViewModel, router: DIContainer.shared.router, appState: DIContainer.shared.appState)
}
