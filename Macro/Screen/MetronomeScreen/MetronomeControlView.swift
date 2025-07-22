//
//  MetronomeControlView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/11/24.
//

import SwiftUI
import Combine

struct MetronomeControlView: View {
    @Namespace var animationNamespace
    
    @State var viewModel: MetronomeControlViewModel = DIContainer.shared.controlViewModel
    private let threshold: CGFloat = 10 // 드래그 시 숫자변동 빠르기 조절 위한 변수
    @State private var tapFeedback: Int = 0
    @State private var isChangeBpm: Bool = false
    
    @State private var isFold: Bool = false
    @State private var isBounce: Bool = false
    @State private var longPressWorkItem: DispatchWorkItem?
    
    @State private var appState: AppState = DIContainer.shared.appState
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(systemName: "chevron.down")
                .rotationEffect(.degrees(isFold ? 180 : 0))
                .bold()
                .foregroundStyle(.textQuaternary)
                .frame(width: 24, height: 24)
                .padding(.horizontal, 18)
                .padding(.vertical, 6)
                .background {
                    UnevenRoundedRectangle(topLeadingRadius: 12, topTrailingRadius: 12)
                        .foregroundStyle(.backgroundCard)
                }
                .onTapGesture {
                    if self.appState.newFeatureBadge == false {
                        self.appState.checkNewFeatureBadge()
                    }
                    withAnimation {
                        isFold.toggle()
                    }
                }
                .offset(y: -36)
            
            let layout = isFold
            ? AnyLayout(HStackLayout(spacing: 0))
            : AnyLayout(VStackLayout(alignment: .center, spacing: 0))
            
            // 드래그 제스쳐 되어야 하는 영역 - BPM
            layout {
                if isFold { // 접힌 BPM
                    HStack(spacing: 0) {
                        Image(systemName: "minus")
                            .font(.system(size: 17))
                            .foregroundStyle(.textQuaternary)
                            .frame(width: 16, height: 16)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                isChangeBpm = true
                                tapOnceAction(isIncreasing: false)
                            }
                            .onLongPressGesture(minimumDuration: 0.5, pressing: { isPressing in
                                isChangeBpm = true
                                tapTwiceAction(isIncreasing: false, isPressing: isPressing)
                            }, perform: {})
                            .matchedGeometryEffect(id: "minusButton", in: animationNamespace)
                        
                        Text("\(self.viewModel.state.bpm)")
                            .font(.custom("Pretendard-Medium", fixedSize: 44))
                            .foregroundStyle(self.viewModel.state.isTapping ? .textBPMSearch : .textSecondary)
                            .frame(width: 100)
                            .background(self.viewModel.state.isTapping ? .backgroundDefault : .clear)
                            .cornerRadius(16)
                            .matchedGeometryEffect(id: "bpm", in: animationNamespace)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 17))
                            .foregroundStyle(.textQuaternary)
                            .frame(width: 16, height: 16)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                isChangeBpm = true
                                tapOnceAction(isIncreasing: true)
                            }
                            .onLongPressGesture(minimumDuration: 0.5, pressing: { isPressing in
                                isChangeBpm = true
                                tapTwiceAction(isIncreasing: true, isPressing: isPressing)
                            }, perform: {})
                            .matchedGeometryEffect(id: "plusButton", in: animationNamespace)
                    }
                    .sensoryFeedback(.selection, trigger: self.viewModel.state.bpm) { _, _ in
                        return isChangeBpm
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.leading, 4)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                isChangeBpm = true
                                dragAction(gesture: gesture)
                            }
                            .onEnded { _ in
                                dragEnded()
                            }
                    )
                } else { // 기본 BPM
                    VStack(alignment: .center, spacing: 10) {
                        if !self.viewModel.state.isTapping {
                            Text("빠르기(BPM)")
                                .font(.Callout_R)
                                .foregroundStyle(.textTertiary)
                                .frame(height: 32)
                        } else {
                            Text("원하는 빠르기로 계속 탭해주세요")
                                .font(.Body_SB)
                                .foregroundStyle(.textDefault)
                                .frame(height: 32)
                                .padding(.horizontal, 16)
                                .background(.backgroundDefault)
                                .cornerRadius(8)
                        }
                        
                        HStack(spacing: 12) {
                            Circle()
                                .fill(self.viewModel.state.isMinusActive ? .buttonBPMControlActive : .buttonBPMControlDefault)
                                .frame(width: 56)
                                .overlay {
                                    Image(systemName: "minus")
                                        .font(.system(size: 26))
                                        .foregroundStyle(.textButtonSecondary)
                                }
                                .onTapGesture {
                                    isChangeBpm = true
                                    tapOnceAction(isIncreasing: false)
                                }
                                .onLongPressGesture(minimumDuration: 0.5, pressing: { isPressing in
                                    isChangeBpm = true
                                    tapTwiceAction(isIncreasing: false, isPressing: isPressing)
                                }, perform: {})
                                .matchedGeometryEffect(id: "minusButton", in: animationNamespace)
                            
                            Text("\(self.viewModel.state.bpm)")
                                .font(.custom("Pretendard-Medium", fixedSize: 64))
                                .foregroundStyle(self.viewModel.state.isTapping ? .textBPMSearch : .textSecondary)
                                .frame(width: 120, height: 60)
                                .padding(8)
                                .background(self.viewModel.state.isTapping ? .backgroundDefault : .clear)
                                .cornerRadius(16)
                                .matchedGeometryEffect(id: "bpm", in: animationNamespace)
                            
                            Circle()
                                .fill(self.viewModel.state.isPlusActive ? .buttonBPMControlActive : .buttonBPMControlDefault)
                                .frame(width: 56)
                                .overlay {
                                    Image(systemName: "plus")
                                        .font(.system(size: 26))
                                        .foregroundStyle(.textButtonSecondary)
                                }
                                .onTapGesture {
                                    isChangeBpm = true
                                    tapOnceAction(isIncreasing: true)
                                }
                                .onLongPressGesture(minimumDuration: 0.5, pressing: { isPressing in
                                    isChangeBpm = true
                                    tapTwiceAction(isIncreasing: true, isPressing: isPressing)
                                }, perform: {})
                                .matchedGeometryEffect(id: "plusButton", in: animationNamespace)
                        }
                        .sensoryFeedback(.selection, trigger: self.viewModel.state.bpm) { _, _ in
                            return isChangeBpm
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 28, leading: 0, bottom: 32, trailing: 0))
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                isChangeBpm = true
                                dragAction(gesture: gesture)
                            }
                            .onEnded { _ in
                                dragEnded()
                            }
                    )
                }
                
                // 아래 시작, 탭 버튼
                HStack(spacing: isFold ? 8 : 12) {
                    if isFold {
                        Image(systemName: viewModel.state.isPlaying ? "stop.fill" : "play.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(self.viewModel.state.isPlaying ? .textButtonPrimary : .textButtonEmphasis)
                            .frame(maxWidth: .infinity)
                            .frame(height: 74)
                            .background(self.viewModel.state.isPlaying ? .buttonPlayStop : .buttonPlayStart)
                            .clipShape(RoundedRectangle(cornerRadius: 100))
                            .onTapGesture {
                                self.viewModel.effect(action: .changeIsPlaying)
                            }
                            .matchedGeometryEffect(id: "startButton", in: animationNamespace)
                    } else {
                        Text(self.viewModel.state.isPlaying ? "멈춤" : "시작")
                            .font(.custom("Pretendard-Medium", fixedSize: 32))
                            .kerning(32 * 0.04)
                            .foregroundStyle(self.viewModel.state.isPlaying ? .textButtonPrimary : .textButtonEmphasis)
                            .frame(maxWidth: .infinity)
                            .frame(height: 74)
                            .background(self.viewModel.state.isPlaying ? .buttonPlayStop : .buttonPlayStart)
                            .clipShape(RoundedRectangle(cornerRadius: 100))
                            .onTapGesture {
                                self.viewModel.effect(action: .changeIsPlaying)
                            }
                            .matchedGeometryEffect(id: "startButton", in: animationNamespace)
                    }
                    
                    Text(isFold || self.viewModel.state.isTapping ? "탭" : "빠르기\n찾기")
                        .font(!isFold && self.viewModel.state.isTapping ? .custom("Pretendard-Regular", size: 28) : .custom("Pretendard-Regular", size: 17))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(self.viewModel.state.isTapping ? .textButtonEmphasis : .textButtonPrimary)
                        .frame(width: isFold ? 74 : 112, height: 74)
                        .background(self.viewModel.state.isTapping ? .buttonActive : .buttonPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                        .onTapGesture {
                            self.viewModel.effect(action: .estimateBpm)
                            self.tapFeedback += 1
                        }
                        .sensoryFeedback(.impact(flexibility: .rigid), trigger: self.tapFeedback)
                }
                .padding(
                    isFold
                    ? EdgeInsets(top: 24, leading: 0, bottom: 24, trailing: 12)
                    : EdgeInsets(top: 0, leading: 12, bottom: 24, trailing: 12)
                )
            }
            .background {
                Rectangle()
                    .foregroundStyle(.backgroundCard)
            }
            .clipShape(
                UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 24, bottomTrailingRadius: 24)
            )
            
            // MARK: 신규 추가 기능
            if self.appState.newFeatureBadge == false {
                Image(.newFeaturePoint)
                    .resizable()
                    .frame(width: 56, height: 39)
                    .shadow(color: .bakBarActiveBottom.opacity(0.5), radius: 20)
                .offset(x: -2, y: isBounce ? -70 : -68)
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 1.8, repeats: true) { _ in
                        withAnimation(.interpolatingSpring(stiffness: 300, damping: 10)) {
                                isBounce = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.interpolatingSpring(stiffness: 300, damping: 10)) {
                                    isBounce = false
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation(.interpolatingSpring(stiffness: 300, damping: 10)) {
                                        isBounce = true
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        withAnimation(.interpolatingSpring(stiffness: 300, damping: 10)) {
                                            isBounce = false
                                        }
                                    }
                                }
                            }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
    
    private func startLongPressTimer(isIncreasing: Bool) {
        self.viewModel.effect(action: .setSpeed(speed: 0.5))
        
        longPressWorkItem = DispatchWorkItem {
            self.viewModel.effect(action: isIncreasing ? .increaseLongBpm(currentBpm: self.viewModel.state.bpm) : .decreaseLongBpm(currentBpm: self.viewModel.state.bpm))
            self.viewModel.effect(action: .setSpeed(speed: max(0.08, self.viewModel.state.speed * 0.9)))
            
            if let workItem = self.longPressWorkItem, !workItem.isCancelled {
                DispatchQueue.main.asyncAfter(deadline: .now() + self.viewModel.state.speed, execute: workItem)
            }
        }
        
        if let workItem = self.longPressWorkItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.viewModel.state.speed, execute: workItem)
        }
    }
    
    private func stopLongPressTimer() {
        longPressWorkItem?.cancel()
        longPressWorkItem = nil
    }
    
    // 단일탭 액션
    private func tapOnceAction(isIncreasing: Bool) {
        self.viewModel.effect(action: isIncreasing ? .increaseShortBpm : .decreaseShortBpm)
        
        withAnimation {
            self.viewModel.effect(action: .toggleActiveState(isIncreasing: isIncreasing, isActive: true))
        }
        
        // 클릭 후 다시 비활성화 색상
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation {
                self.viewModel.effect(action: .toggleActiveState(isIncreasing: isIncreasing, isActive: false))
            }
        }
    }
    
    // 롱탭 액션
    private func tapTwiceAction(isIncreasing: Bool, isPressing: Bool) {
        withAnimation {
            self.viewModel.effect(action: .toggleActiveState(isIncreasing: isIncreasing, isActive: isPressing))
        }
        
        if isPressing {
            startLongPressTimer(isIncreasing: isIncreasing)
        } else {
            stopLongPressTimer()
        }
    }
    
    // 드래그 제스쳐 액션
    private func dragAction(gesture: DragGesture.Value) {
        // 현재 위치값을 기준으로 증감 측정
        let translationDifference = gesture.translation.width - self.viewModel.state.previousTranslation
        
        if abs(translationDifference) > threshold {   // 음수값도 있기 때문에 절댓값 사용
            if translationDifference > 0 {
                self.viewModel.effect(action: .increaseShortBpm)
                self.viewModel.effect(action: .toggleActiveState(isIncreasing: true, isActive: true))
                self.viewModel.effect(action: .toggleActiveState(isIncreasing: false, isActive: false))
            } else if translationDifference < 0 {
                self.viewModel.effect(action: .decreaseShortBpm)
                self.viewModel.effect(action: .toggleActiveState(isIncreasing: false, isActive: true))
                self.viewModel.effect(action: .toggleActiveState(isIncreasing: true, isActive: false))
            }
            
            self.viewModel.effect(action: .setPreviousTranslation(position: gesture.translation.width))
        }
    }
    
    // 드래그 제스쳐 끝났을 때
    private func dragEnded() {
        self.viewModel.effect(action: .toggleActiveState(isIncreasing: false, isActive: false))
        self.viewModel.effect(action: .toggleActiveState(isIncreasing: true, isActive: false))
        self.viewModel.effect(action: .setPreviousTranslation(position: 0))
    }
}

#Preview {
    MetronomeControlView()
}
