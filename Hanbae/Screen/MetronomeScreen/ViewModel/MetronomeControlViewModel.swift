//
//  MetronomeControlViewModel.swift
//  Macro
//
//  Created by Lee Wonsun on 11/19/24.
//

import SwiftUI
import Combine

@Observable
class MetronomeControlViewModel {
    
    private var cancelBag: Set<AnyCancellable> = []
    private var jangdanRepository: JangdanRepository
    private var tempoUseCase: TempoUseCase
    private var metronomeOnOffUseCase: MetronomeOnOffUseCase
    
    private var widgetManager: WidgetManager
    
    // Analytics
    private var analyticsService: AnalyticsServiceInterface
    private var appState: AppState
    private var startTime: Date?
    private var jangdanName: String?
    
    init(jangdanRepository: JangdanRepository, tempoUseCase: TempoUseCase, metronomeOnOffUseCase: MetronomeOnOffUseCase, widgetManager: WidgetManager, appState: AppState, analyticsService: AnalyticsServiceInterface) {
        self.jangdanRepository = jangdanRepository
        self.tempoUseCase = tempoUseCase
        self.metronomeOnOffUseCase = metronomeOnOffUseCase
        
        self.widgetManager = widgetManager
        
        self.analyticsService = analyticsService
        self.appState = appState
        
        self.tempoUseCase.isTappingPublisher.sink { [weak self] isTapping in
            guard let self else { return }
            self.state.isTapping = isTapping
        }
        .store(in: &self.cancelBag)
        
        self.jangdanRepository.jangdanPublisher.sink { [weak self] jangdan in
            guard let self else { return }
            self.state.bpm = jangdan.bpm
            jangdanName = jangdan.name
        }
        .store(in: &self.cancelBag)
        
        self.metronomeOnOffUseCase.isPlayingPublisher.sink { [weak self] isPlaying in
            guard let self else { return }
            self.state.isPlaying = isPlaying
        }
        .store(in: &self.cancelBag)
    }
    
    private(set) var state: State = .init()
    
    struct State {
        var isPlaying: Bool = false
        var isMinusActive: Bool = false
        var isPlusActive: Bool = false
        var previousTranslation: CGFloat = .zero
        var speed: TimeInterval = 0.5
        var isTapping: Bool = false
        var bpm: Int = 60
    }
}

extension MetronomeControlViewModel {
    enum Action {
        case changeIsPlaying
        case decreaseShortBpm
        case decreaseLongBpm(currentBpm: Int)
        case increaseShortBpm
        case increaseLongBpm(currentBpm: Int)
        case roundBpm(currentBpm: Int)
        case estimateBpm
        case toggleActiveState(isIncreasing: Bool, isActive: Bool)
        case setPreviousTranslation(position: CGFloat)
        case setSpeed(speed: TimeInterval)
    }
    
    func effect(action: Action) {
        switch action {
        case .changeIsPlaying:
            if self.state.isPlaying {
                self.metronomeOnOffUseCase.stop()
                Task {
                    await self.widgetManager.endLiveActivity()
                }
                
                #if RELEASE
                guard let startTime, let jangdanName else { return }
                let duration: Double = Date.now.timeIntervalSince(startTime)
                let roundedDuration: Double = round(100 * duration) / 100
                self.analyticsService.track(event: .metronomePlay(jangdan: jangdanName, duration: roundedDuration, soundType: appState.selectedSound.name))
                self.startTime = nil
                #endif
            } else {
                self.startTime = .now
                self.metronomeOnOffUseCase.play()
            }
        case .decreaseShortBpm:
            self.tempoUseCase.updateTempo(newBpm: self.state.bpm - 1)
            self.tempoUseCase.finishTapping()
        case let .decreaseLongBpm(currentBpm):
            let remainder = currentBpm % 10
            let roundedBpm = remainder == 0 ? currentBpm - 10 : currentBpm - remainder
            self.tempoUseCase.updateTempo(newBpm: roundedBpm)
            self.tempoUseCase.finishTapping()
        case .increaseShortBpm:
            self.tempoUseCase.updateTempo(newBpm: self.state.bpm + 1)
            self.tempoUseCase.finishTapping()
        case let .increaseLongBpm(currentBpm):
            let remainder = currentBpm % 10
            let roundedBpm = remainder == 0 ? currentBpm + 10 : currentBpm + (10 - remainder)
            self.tempoUseCase.updateTempo(newBpm: roundedBpm)
            self.tempoUseCase.finishTapping()
        case let .roundBpm(currentBpm):
            self.tempoUseCase.updateTempo(newBpm: currentBpm)
        case .estimateBpm:
            self.tempoUseCase.tap()
        case let .toggleActiveState(isIncreasing, isActive):
            if isIncreasing {
                self.state.isPlusActive = isActive
            } else {
                self.state.isMinusActive = isActive
            }
        case let .setPreviousTranslation(position):
            self.state.previousTranslation = position
        case let .setSpeed(speed):
            self.state.speed = speed
        }
    }
}
