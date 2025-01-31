//
//  MetronomeViewModel.swift
//  Macro
//
//  Created by Yunki on 10/30/24.
//

import SwiftUI
import Combine

@Observable
class MetronomeViewModel {
    private var templateUseCase: TemplateUseCase
    private var metronomeOnOffUseCase: MetronomeOnOffUseCase
    private var accentUseCase: AccentUseCase
    private var taptapUseCase: TapTapUseCase
    
    private var cancelBag: Set<AnyCancellable> = []
    
    init(templateUseCase: TemplateUseCase, metronomeOnOffUseCase: MetronomeOnOffUseCase, tempoUseCase: TempoUseCase, accentUseCase: AccentUseCase, taptapUseCase: TapTapUseCase) {
        
        self.templateUseCase = templateUseCase
        self.metronomeOnOffUseCase = metronomeOnOffUseCase
        self.accentUseCase = accentUseCase
        self.taptapUseCase = taptapUseCase
        
        self.templateUseCase.currentJangdanTypePublisher.sink { [weak self] jangdanType in
            guard let self else { return }
            self.state.currentJangdanType = jangdanType
        }
        .store(in: &self.cancelBag)
        
        self.accentUseCase.accentListPublisher.sink { [weak self] accentList in
            guard let self else { return }
            self.state.jangdanAccent = accentList
        }
        .store(in: &self.cancelBag)
        
        self.taptapUseCase.isTappingPublisher.sink { [weak self] isTapping in
            guard let self else { return }
            self.state.isTapping = isTapping
        }
        .store(in: &self.cancelBag)
        
        self.metronomeOnOffUseCase.isPlayingPublisher.sink { [weak self] isPlaying in
            guard let self else { return }
            self.state.isPlaying = isPlaying
        }
        .store(in: &self.cancelBag)
        
        self.metronomeOnOffUseCase.isSobakOnPublisher.sink { [weak self] isSobakOn in
            guard let self else { return }
            self.state.isSobakOn = isSobakOn
        }
        .store(in: &self.cancelBag)
        
        self.metronomeOnOffUseCase.tickPublisher.sink { [weak self] currentBakIndex in
            guard let self else { return }
            self.state.currentSobak = currentBakIndex.0
            self.state.currentDaebak = currentBakIndex.1
            self.state.currentRow = currentBakIndex.2
        }
        .store(in: &self.cancelBag)
    }
    
    private(set) var state: State = .init()
    
    struct State {
        var currentJangdanName: String?
        var currentJangdanType: Jangdan?
        var jangdanAccent: [[[Accent]]] = []
        var isSobakOn: Bool = false
        var isPlaying: Bool = false
        var isTapping: Bool = false
        var isBlinkOn: Bool = false
        var currentSobak: Int = 0
        var currentDaebak: Int = 0
        var currentRow: Int = 0
    }
}

extension MetronomeViewModel {
    enum Action: Equatable {
        case selectJangdan(selectedJangdanName: String)
        case changeSobakOnOff
        case changeAccent(row: Int, daebak: Int, sobak: Int, newAccent: Accent)
        case stopMetronome
        case estimateBpm
        case disableEstimateBpm
        case changeBlinkOnOff
    }
    
    func effect(action: Action) {
        if action != .estimateBpm {
            self.taptapUseCase.finishTapping()
        }
        
        switch action {
        case let .selectJangdan(jangdanName):
            self.state.currentJangdanName = jangdanName
            self.templateUseCase.setJangdan(jangdanName: jangdanName)
            self.metronomeOnOffUseCase.initialDaeSoBakIndex()
            self.taptapUseCase.finishTapping()
            if self.state.isSobakOn {
                self.metronomeOnOffUseCase.changeSobak()
            }
        case .changeSobakOnOff:
            self.metronomeOnOffUseCase.changeSobak()
            
        case let .changeAccent(row, daebak, sobak, newAccent):
            self.accentUseCase.moveNextAccent(rowIndex: row, daebakIndex: daebak, sobakIndex: sobak, to: newAccent)
        case .stopMetronome: // 시트 변경 시 소리 중지를 위해 사용함
            if self.state.isSobakOn {
                self.metronomeOnOffUseCase.changeSobak()
            }
            self.metronomeOnOffUseCase.stop()
        case .estimateBpm:
            self.taptapUseCase.tap()
        case .disableEstimateBpm:
            self.taptapUseCase.finishTapping()
        case .changeBlinkOnOff:
            self.state.isBlinkOn.toggle()
        }
    }
}
