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
    private var taptapUseCase: TapTapUseCase
    private var tempoUseCase: TempoUseCase
    private var metronomeOnOffUseCase: MetronomeOnOffUseCase
    
    var timerCancellable: AnyCancellable?
    
    init(jangdanRepository: JangdanRepository, taptapUseCase: TapTapUseCase, tempoUseCase: TempoUseCase, metronomeOnOffUseCase: MetronomeOnOffUseCase) {
        self.jangdanRepository = jangdanRepository
        self.taptapUseCase = taptapUseCase
        self.tempoUseCase = tempoUseCase
        self.metronomeOnOffUseCase = metronomeOnOffUseCase
        
        self.timerCancellable = nil
        
        self.taptapUseCase.isTappingPublisher.sink { [weak self] isTapping in
            guard let self else { return }
            self._state.isTapping = isTapping
        }
        .store(in: &self.cancelBag)
        
        self.jangdanRepository.jangdanPublisher.sink { [weak self] jangdan in
            guard let self else { return }
            self._state.bpm = jangdan.bpm
        }
        .store(in: &self.cancelBag)
        
        self.metronomeOnOffUseCase.isPlayingPublisher.sink { [weak self] isPlaying in
            guard let self else { return }
            self._state.isPlaying = isPlaying
        }
        .store(in: &self.cancelBag)
    }
    
    private var _state: State = .init()
    var state: State {
        return _state
    }
    
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
        case .decreaseShortBpm:
            self.tempoUseCase.updateTempo(newBpm: self._state.bpm - 1)
            self.taptapUseCase.finishTapping()
        case let .decreaseLongBpm(currentBpm):
            let remainder = currentBpm % 10
            let roundedBpm = remainder == 0 ? currentBpm + remainder : currentBpm + (10 - remainder)
            self.tempoUseCase.updateTempo(newBpm: roundedBpm - 10)
            self.taptapUseCase.finishTapping()
        case .increaseShortBpm:
            self.tempoUseCase.updateTempo(newBpm: self._state.bpm + 1)
            self.taptapUseCase.finishTapping()
        case let .increaseLongBpm(currentBpm):
            let roundedBpm = currentBpm - (currentBpm % 10)
            self.tempoUseCase.updateTempo(newBpm: roundedBpm + 10)
            self.taptapUseCase.finishTapping()
        case let .roundBpm(currentBpm):
            self.tempoUseCase.updateTempo(newBpm: currentBpm)
        case .estimateBpm:
            self.taptapUseCase.tap()
        case let .toggleActiveState(isIncreasing, isActive):
            if isIncreasing {
                self._state.isPlusActive = isActive
            } else {
                self._state.isMinusActive = isActive
            }
        case let .setPreviousTranslation(position):
            self._state.previousTranslation = position
        case let .setSpeed(speed):
            self._state.speed = speed
        }
    }
}
