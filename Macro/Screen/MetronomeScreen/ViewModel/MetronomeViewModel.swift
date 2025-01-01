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
            self.initialDaeSoBakIndex()
            self.state.isPlaying = isPlaying
        }
        .store(in: &self.cancelBag)
        
        self.metronomeOnOffUseCase.isSobakOnPublisher.sink { [weak self] isSobakOn in
            guard let self else { return }
            self.state.isSobakOn = isSobakOn
        }
        .store(in: &self.cancelBag)
        
        self.metronomeOnOffUseCase.tickPublisher.sink { [weak self] _ in
            guard let self else { return }
            self.updateStatePerBak()
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
    }
    
    func effect(action: Action) {
        if action != .estimateBpm {
            self.taptapUseCase.finishTapping()
        }
        
        switch action {
        case let .selectJangdan(jangdanName):
            self.state.currentJangdanName = jangdanName
            self.templateUseCase.setJangdan(jangdanName: jangdanName)
            self.initialDaeSoBakIndex()
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
        }
    }
    
    private func updateStatePerBak() {
        var nextSobak: Int = self.state.currentSobak
        var nextDaebak: Int = self.state.currentDaebak
        var nextRow: Int = self.state.currentRow
        
        nextSobak += 1
        if nextSobak == self.state.jangdanAccent[nextRow][nextDaebak].count {
            nextDaebak += 1
            if nextDaebak == self.state.jangdanAccent[nextRow].count {
                nextRow += 1
                if nextRow == self.state.jangdanAccent.count {
                    nextRow = 0
                }
                nextDaebak = 0
            }
            nextSobak = 0
        }
        
        self.state.currentSobak = nextSobak
        self.state.currentDaebak = nextDaebak
        self.state.currentRow = nextRow
    }
    
    private func initialDaeSoBakIndex() {
        self.state.currentRow = self.state.jangdanAccent.count - 1
        self.state.currentDaebak = self.state.jangdanAccent[self.state.currentRow].count - 1
        self.state.currentSobak = self.state.jangdanAccent[self.state.currentRow][self.state.currentDaebak].count - 1
    }
}
