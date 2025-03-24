//
//  HomeView.swift
//  Macro
//
//  Created by Yunki on 11/12/24.
//

import SwiftUI
import StoreKit

struct HomeView: View {
    @Environment(\.requestReview) private var requestReview
    @State private var viewModel: HomeViewModel
    @State private var scrollOffset: CGFloat = 0
    
    private var router: Router
    private var appState: AppState
    
    init(viewModel: HomeViewModel, router: Router, appState: AppState) {
        self.viewModel = viewModel
        self.router = router
        self.appState = appState
    }
    
    private let columns: [GridItem] = .init(repeating: GridItem(.flexible(), spacing: 8), count: 2)
    
    var body: some View {
        ZStack {
            NavigationStack(path: Binding(
                get: { router.path }, set: { router.path = $0 }
            ))
            {
                VStack(spacing: 0) {
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
                    
                    GeometryReader { geo in
                        ZStack(alignment: .top) {
                            ScrollView {
                                // MARK: - 기본 장단 목록 (2칸씩 수직 그리드)
                                VStack(spacing: 0) {
                                    // 스크롤 트래킹용 투명 View
                                    scrollObservableView
                                    
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
                                        LazyVGrid(columns: columns, spacing: 8) {
                                            ForEach(self.appState.selectedInstrument.defaultJangdans, id: \.self) { jangdan in
                                                Button(jangdan.name) {
                                                    self.router.push(.builtInJangdanPractice(jangdanName: jangdan.name))
                                                    self.appState.increaseEnteredJangdan()
                                                    if self.appState.numberOfEnteredJangdan % 100 == 0 {
                                                        self.requestReview()
                                                    }
                                                }
                                                .buttonStyle(JangdanLogoButtonStyle(jangdan: jangdan))
                                            }
                                        }
                                    }
                                    .padding(.bottom, 38.5)
                                }
                            }
                            .onPreferenceChange(ScrollPreferenceKey.self) { value in
                                // 스크롤 내부 View의 최상단 - 스크롤뷰의 최상단
                                self.scrollOffset = value - geo.frame(in: .global).origin.y
                            }
                            .scrollIndicators(.hidden)
                            .ignoresSafeArea(edges: .bottom)
                            .padding(.horizontal, 16)
                            .navigationDestination(for: Route.self) { path in
                                router.view(for: path)
                            }
                            
                            Rectangle()
                                .foregroundStyle(LinearGradient(colors: [.black, .black.opacity(0)], startPoint: .top, endPoint: .bottom))
                                .frame(height: min(36, max(-self.scrollOffset, 0)))
                        }
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
    private struct JangdanLogoButtonStyle: ButtonStyle {
        @State private var isPressed: Bool?
        @State private var isRealPressed: Bool = false
        
        var jangdan: Jangdan
        
        func makeBody(configuration: Configuration) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(isPressed == true ? .buttonActive : .backgroundCard) // 배경색 설정
                    .shadow(radius: 5) // 그림자 효과
                    .overlay {
                        jangdan.jangdanLogoImage
                            .resizable()
                            .foregroundStyle(isPressed == true ? .backgroundImageActive : .backgroundImageDefault)
                            .frame(width: 225, height: 225)
                            .offset(y: -116)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Text(jangdan.name)
                    .font(isPressed == true ? .Title1_B : .Title1_R)
                    .foregroundStyle(isPressed == true ? .textButtonEmphasis : .textDefault)
                    .offset(y: -2.5)
                
                Text(jangdan.bakInformation)
                    .font(.Body_R)
                    .foregroundStyle(isPressed == true ? .textButtonEmphasis : .textDefault)
                    .offset(y: 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fill)
            .animation(nil, value: configuration.isPressed) // 기존 버튼에 따른 애니메이션은 제거
            .contentShape(Rectangle())
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if isPressed == nil { // 처음 탭될때만 버튼 Active
                            isPressed = true
                        } else if !configuration.isPressed { // 버튼 자체적으로 isPressed 상태가 해제되는경우 deActive
                            withAnimation(.linear(duration: 0.2)) {
                                isPressed = false
                            }
                        }
                    }
                    .onEnded { _ in // 제스처 끝날때 도로 nil로 초기화
                        if isPressed == true {
                            self.isRealPressed = true
                        }
                        withAnimation {
                            isPressed = nil
                        }
                    }
            )
            .sensoryFeedback(.impact(weight: .medium), trigger: isRealPressed) { _, newValue in
                self.isRealPressed = false
                return newValue
            }
        }
    }
}

extension HomeView {
    struct ScrollPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = .zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { }
    }
    
    private var scrollObservableView: some View {
        GeometryReader { proxy in
            let offsetY = proxy.frame(in: .global).origin.y
            Color.clear
                .preference(
                    key: ScrollPreferenceKey.self,
                    value: offsetY
                )
        }
        .frame(height: 0)
    }
}

#Preview {
    HomeView(viewModel: DIContainer.shared.homeViewModel, router: DIContainer.shared.router, appState: DIContainer.shared.appState)
}
