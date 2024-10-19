//
//  MetronomeView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/10/24.
//

import SwiftUI
import Combine

struct MetronomeView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var viewModel: MetronomeViewModel
    
    @State private var jangdan: Jangdan
    @State private var isSheetPresented: Bool = false
    @State private var isSobakOn: Bool = false
    
    @State private var circleXPosition: CGFloat = 0.0
    @State private var movingRight: Bool = true // 원이 오른쪽으로 이동 중인지 추적
    @State private var timer: Timer? = nil
    
    init(jangdan: Jangdan) {
        self.jangdan = jangdan
        self.viewModel = MetronomeViewModel()
        self.viewModel.effect(action: .selectJangdan(jangdan: jangdan))
        self.isSobakOn = self.viewModel.state.isSobakOn
    }
    
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                DaebakPendulumView(trigger: self.viewModel.state.pendulumTrigger)
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                
//                daebakPendulumView()
//                    .padding(.top, 24)
//                    .padding(.bottom, 16)
                
                BakBarSetView(
                    viewModel: self.viewModel,
                    bakCount: viewModel.state.bakCount,
                    daebakCount: viewModel.state.daebakCount,
                    daebakList: viewModel.state.jangdanAccent,
                    isSobakMode: viewModel.state.isSobakOn, // 소박 모드
                    isPlaying: viewModel.state.isPlaying, // 재생 중 상태
                    currentIndex: viewModel.state.currentIndex // 현재 인덱스
                )
                .padding(.bottom, 26)
                
                SobakToggleView(isSobakOn: $isSobakOn, jangdan: viewModel.state.currentJangdan)
                    .padding(.bottom, 16)
                    
                
                MetronomeControlView(viewModel: viewModel)

            }
            .onChange(of: isSobakOn) {
                self.viewModel.effect(action: .changeSobakOnOff)
            }
            .onChange(of: self.viewModel.state.isPlaying) { newValue in
                if newValue {
                    startMoving(currentBpm: viewModel.state.bpm, geoSize: geo.size)
                } else {
                    stopMoving()
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                // 뒤로가기 chevron
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.viewModel.effect(action: .stopMetronome)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.textDefault)
                    }
                }
                
                // 장단 선택 List title
                ToolbarItem(placement: .principal) {
                    Button(action: {
                        isSheetPresented.toggle()
                    }) {
                        HStack(spacing: 0) {
                            Text("\(jangdan.name)")
                                .font(.Body_R)
                                .foregroundStyle(.textSecondary)
                                .padding(.trailing, 6)
                            
                            Image(systemName: "chevron.down")
                                .foregroundStyle(.textSecondary)
                                .font(.system(size: 12))
                        }
                    }
                }
            }
            .toolbarBackground(.navigationbarbackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarTitleDisplayMode(.inline)
            .sheet(isPresented: $isSheetPresented) {
                JangdanSelectSheetView(jangdan: $jangdan, isSheetPresented: $isSheetPresented, sendJangdan: {
                    self.viewModel.effect(action: .stopMetronome)
                    self.isSobakOn = false // view의 소박보기 false
                    self.viewModel.effect(action: .selectJangdan(jangdan: jangdan))
                })
                    .presentationDragIndicator(.visible)
            }
            .onAppear {
                circleXPosition = 0
            }
        }
    }
    
    // 대박 펜듈럼 뷰
    @ViewBuilder
    func daebakPendulumView() -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 100)
                .frame(height: 16)
                .foregroundStyle(.bakbarInactive) // 임시 색상
                .padding(.horizontal, 8)
            
            Circle()
                .frame(width: 16)
                .offset(x: circleXPosition + 8)
        }
        .frame(maxWidth: .infinity)
    }

    // 팬듈럼 작동 함수
    func startMoving(currentBpm: Int, geoSize: CGSize) {
        let rectangleWidth: CGFloat = CGFloat(geoSize.width) - 16
        let bakTime: CGFloat = 60 / CGFloat(currentBpm)
        let distancePerSecond: CGFloat = (rectangleWidth - 16) / bakTime
        
        // 시작(실행)
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            let movement: CGFloat = movingRight ? distancePerSecond * 0.01 : -distancePerSecond * 0.01
            
            circleXPosition += movement
            
            // 한쪽 끝에 도달하면 방향 반대로 변경
            if circleXPosition >= (rectangleWidth - 16) {
                movingRight = false
            } else if circleXPosition <= 0 {
                movingRight = true
            }
        }
    }
    
    // 타이머 중지 함수
    func stopMoving() {
        circleXPosition = 0
        timer?.invalidate() // 타이머 해제
        timer = nil
    }
}

@Observable
class MetronomeViewModel {
    private var templateUseCase: TemplateUseCase
    private var metronomeOnOffUseCase: MetronomeOnOffUseCase
    private var tempoUseCase: TempoUseCase
    private var accentUseCase: AccentUseCase
    
    private var jangdanUISubscriber: AnyCancellable?
    private var bpmSubscriber: AnyCancellable?
    private var cancelBag: Set<AnyCancellable> = []
    
    init() {
        let initTemplateUseCase = TemplateUseCase(jangdanRepository: JangdanRepository())
        self.templateUseCase = initTemplateUseCase
        let initSoundManager: SoundManager? = .init()
        // TODO: SoundManager 에러처리하고 언래핑 풀어주기~
        self.metronomeOnOffUseCase = MetronomeOnOffUseCase(templateUseCase: initTemplateUseCase, soundManager: initSoundManager!)
        self.tempoUseCase = TempoUseCase(templateUseCase: initTemplateUseCase)
        self.accentUseCase = AccentUseCase(templateUseCase: initTemplateUseCase)
        self.jangdanUISubscriber = self.templateUseCase.jangdanUIPublisher.sink { [weak self] jangdanUI in
            guard let self else { return }
            self._state.jangdanAccent = jangdanUI
        }
        self.jangdanUISubscriber?.store(in: &self.cancelBag)
        self.bpmSubscriber = self.templateUseCase.bpmUIPublisher.sink { [weak self] bpm in
            guard let self else { return }
            self._state.bpm = bpm
        }
        self.bpmSubscriber?.store(in: &self.cancelBag)
    }
    
    private var _state: State = .init()
    var state: State {
        return _state
    }
    
    struct State {
        var currentJangdan: Jangdan?
        var jangdanAccent: [[Accent]] = []
        var bakCount: Int = 0
        var daebakCount: Int = 0
        var isSobakOn: Bool = false
        var isPlaying: Bool = false
        var currentIndex: Int = -1
        var bpm: Int = 60
        var pendulumTrigger: Bool = false
    }
    
    enum Action {
        case selectJangdan(jangdan: Jangdan)
        case changeSobakOnOff
        case changeIsPlaying
        case decreaseBpm // - button
        case increaseBpm // + button
        case changeAccent(daebak: Int, sobak: Int)
        case stopMetronome
    }
    
    func effect(action: Action) {
        switch action {
        case let .selectJangdan(jangdan):
            self._state.currentJangdan = jangdan
            self.templateUseCase.setJangdan(jangdan: jangdan)
            self._state.bakCount = self.templateUseCase.currentJangdanBakCount
            self._state.daebakCount = self.templateUseCase.currentJangdanDaebakCount
        case .changeSobakOnOff:
            self._state.isSobakOn.toggle()
            self.templateUseCase.changeSobakOnOff()
            if self._state.isPlaying {
                self.metronomeOnOffUseCase.stop()
                self._state.currentIndex = -1
                self.metronomeOnOffUseCase.play {
                    self._state.currentIndex += 1
                    self._state.currentIndex %= self._state.isSobakOn ? self._state.bakCount : self._state.daebakCount
                }
            }
        case .changeIsPlaying:
            self._state.currentIndex = -1
            self._state.isPlaying.toggle()
            if self._state.isPlaying {
                self.metronomeOnOffUseCase.play {
                    withAnimation(.snappy(duration: 60.0 / Double(self._state.bpm))) {
                        self._state.pendulumTrigger.toggle()
                    }
                    
                    self._state.currentIndex += 1
                    self._state.currentIndex %= self._state.isSobakOn ? self._state.bakCount : self._state.daebakCount
                }
            } else {
                withAnimation {
                    self._state.pendulumTrigger = false
                }
                self.metronomeOnOffUseCase.stop()
            }
        case .decreaseBpm:
            self.tempoUseCase.updateTempo(newBpm: self._state.bpm - 1)
            
        case .increaseBpm:
            self.tempoUseCase.updateTempo(newBpm: self._state.bpm + 1)
            
        case let .changeAccent(daebak, sobak):
            self.accentUseCase.moveNextAccent(daebakIndex: daebak, sobakIndex: sobak)
        case .stopMetronome:
            self._state.isPlaying = false
            self.metronomeOnOffUseCase.stop()
        }
    }
}
