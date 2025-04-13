//
//  CustomJangdanPracticeViewModel.swift
//  Macro
//
//  Created by leejina on 12/18/24.
//

import Foundation
import Combine

@Observable
class CustomJangdanPracticeViewModel {
    
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
        var isRepeatedName: Bool = false
    }
}

extension CustomJangdanPracticeViewModel {
    enum Action {
        case selectJangdan(jangdanName: String)
        case initialJangdan(jangdanName: String)
        case exitMetronome
        case createCustomJangdan(newJangdanName: String)
        case updateCustomJangdan(newJangdanName: String?)
        case deleteCustomJangdanData(jangdanName: String)
        case repeatedNameNoticed
    }
    
    func effect(action: Action) {
        switch action {
        case let .selectJangdan(jangdanName):
            self.templateUseCase.setJangdan(jangdanName: jangdanName)
        case let .initialJangdan(jangdanName):
            self.templateUseCase.setJangdan(jangdanName: jangdanName)
        case .exitMetronome:
            self.metronomeOnOffUseCase.stop()
            Task {
                await self.widgetManager.endLiveActivity()
            }
        case let .createCustomJangdan(newJangdanName):
            do {
                try self.templateUseCase.createCustomJangdan(newJangdanName: newJangdanName)
            } catch {
                self.state.isRepeatedName = true
            }
        case let .updateCustomJangdan(newJangdanName):
            do {
                try self.templateUseCase.updateCustomJangdan(newJangdanName: newJangdanName)
            } catch {
                self.state.isRepeatedName = true
            }
        case let .deleteCustomJangdanData(jangdanName):
            self.templateUseCase.deleteCustomJangdan(jangdanName: jangdanName)
        case .repeatedNameNoticed:
            self.state.isRepeatedName = false
        }
    }
}
