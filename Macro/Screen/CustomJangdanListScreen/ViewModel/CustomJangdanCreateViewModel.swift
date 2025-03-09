//
//  CustomJangdanCreateViewModel.swift
//  Macro
//
//  Created by leejina on 12/18/24.
//

import Foundation
import Combine

@Observable
class CustomJangdanCreateViewModel {
    
    private var templateUseCase: TemplateUseCase
    private var metronomeOnOffUseCase: MetronomeOnOffUseCase
    
    private var widgetManager: WidgetManager
    
    private var cancelbag: Set<AnyCancellable> = []
    
    init(templateUseCase: TemplateUseCase, metronomeOnOffUseCase: MetronomeOnOffUseCase, widgetManager: WidgetManager) {
        self.templateUseCase = templateUseCase
        self.metronomeOnOffUseCase = metronomeOnOffUseCase
        
        self.widgetManager = widgetManager
        
        self.templateUseCase.currentJangdanTypePublisher.sink { [weak self] jangdanType in
            guard let self else { return }
            self.state.currentJangdanType = jangdanType
        }
        .store(in: &cancelbag)
        
    }
    
    private(set) var state: State = .init()
    
    struct State {
        var currentJangdanType: Jangdan?
    }
}

extension CustomJangdanCreateViewModel {
    enum Action {
        case initialJangdan
        case exitMetronome
        case createCustomJangdan(newJangdanName: String)
    }
    
    func effect(action: Action) {
        switch action {
        case .initialJangdan:
            guard let currentJangdanType = self.state.currentJangdanType else { return }
            self.templateUseCase.setJangdan(jangdanName: currentJangdanType.rawValue)
        case .exitMetronome:
            self.metronomeOnOffUseCase.stop()
            Task {
                await self.widgetManager.endLiveActivity()
            }
        case let .createCustomJangdan(newJangdanName):
            try! self.templateUseCase.createCustomJangdan(newJangdanName: newJangdanName)
        }
    }
}
