//
//  MetronomeControlView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/11/24.
//

import SwiftUI
import Combine

struct MetronomeControlView: View {
    
    @State var viewModel: MetronomeControlViewModel = DIContainer.shared.controlViewModel
    private let threshold: CGFloat = 10 // 드래그 시 숫자변동 빠르기 조절 위한 변수
    @State private var tapFeedback: Int = 0
    @State private var isChangeBpm: Bool = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                // 위에 드래그 제스쳐 되어야 하는 영역
                ZStack {
                    Rectangle()
                        .foregroundStyle(.backgroundCard)
                    
                    VStack(alignment: .center, spacing: 10) {
                        if !self.viewModel.state.isTapping {
                            Text("빠르기(BPM)")
                                .font(.Callout_R)
                                .foregroundStyle(.textTertiary)
                                .padding(.vertical, 5)
                        } else {
                            Text("원하는 빠르기로 계속 탭해주세요")
                                .font(.Body_SB)
                                .foregroundStyle(.textDefault)
                                .padding(.vertical, 5)
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
                            
                            Text("\(self.viewModel.state.bpm)")
                                .font(.custom("Pretendard-Medium", fixedSize: 64))
                                .foregroundStyle(self.viewModel.state.isTapping ? .textBPMSearch : .textSecondary)
                                .frame(width: 120, height: 60)
                                .padding(8)
                                .background(self.viewModel.state.isTapping ? .backgroundDefault : .clear)
                                .cornerRadius(16)
                            
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
                        }
                        .sensoryFeedback(.selection, trigger: self.viewModel.state.bpm) { _, _ in
                            return isChangeBpm
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 12, topTrailingRadius: 12))
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
                
                // 아래 시작, 탭 버튼
                HStack(spacing: 16) {
                    Text(self.viewModel.state.isPlaying ? "멈춤" : "시작")
                        .font(.custom("Pretendard-Medium", fixedSize: 34))
                        .foregroundStyle(self.viewModel.state.isPlaying ? .textButtonPrimary : .textButtonEmphasis)
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .background(self.viewModel.state.isPlaying ? .buttonPlayStop : .buttonPlayStart)
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                        .onTapGesture {
                            self.viewModel.effect(action: .changeIsPlaying)
                        }
                    
                    Text(self.viewModel.state.isTapping ? "탭" : "빠르기\n찾기")
                        .font(self.viewModel.state.isTapping ? .custom("Pretendard-Regular", size: 28) : .custom("Pretendard-Regular", size: 17))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(self.viewModel.state.isTapping ? .textButtonEmphasis : .textButtonPrimary)
                        .frame(width: 120, height: 80)
                        .background(self.viewModel.state.isTapping ? .buttonActive : .buttonPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                        .onTapGesture {
                            self.viewModel.effect(action: .estimateBpm)
                            self.tapFeedback += 1
                        }
                        .sensoryFeedback(.impact(flexibility: .rigid), trigger: self.tapFeedback)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 24)
                .background(.backgroundCard)
                .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 24, bottomTrailingRadius: 24))
            }
        }
        .padding(.horizontal, 16)
    }
    
    private func startTimer(isIncreasing: Bool) {
        self.viewModel.effect(action: .setSpeed(speed: 0.5))
        stopTimer()
        self.viewModel.timerCancellable = Timer.publish(every: self.viewModel.state.speed, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if isIncreasing {
                    self.viewModel.effect(action: .increaseLongBpm(currentBpm: self.viewModel.state.bpm))
                    self.viewModel.effect(action: .setSpeed(speed: max(0.08, self.viewModel.state.speed * 0.5)))
                    restartTimer(isIncreasing: isIncreasing)
                } else {
                    self.viewModel.effect(action: .decreaseLongBpm(currentBpm: self.viewModel.state.bpm))
                    self.viewModel.effect(action: .setSpeed(speed: max(0.08, self.viewModel.state.speed * 0.5)))
                    restartTimer(isIncreasing: isIncreasing)
                }
            }
        
    }
    
    private func restartTimer(isIncreasing: Bool) {
        stopTimer()
        self.viewModel.timerCancellable = Timer.publish(every: self.viewModel.state.speed, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if isIncreasing {
                    self.viewModel.effect(action: .increaseLongBpm(currentBpm: self.viewModel.state.bpm))
                    self.viewModel.effect(action: .setSpeed(speed: max(0.08, self.viewModel.state.speed * 0.5)))
                    restartTimer(isIncreasing: isIncreasing)
                } else {
                    self.viewModel.effect(action: .decreaseLongBpm(currentBpm: self.viewModel.state.bpm))
                    self.viewModel.effect(action: .setSpeed(speed: max(0.08, self.viewModel.state.speed * 0.5)))
                    restartTimer(isIncreasing: isIncreasing)
                }
            }
    }
    
    private func stopTimer() {
        self.viewModel.timerCancellable?.cancel()
        self.viewModel.timerCancellable = nil
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
            startTimer(isIncreasing: isIncreasing)
        } else {
            stopTimer()
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
