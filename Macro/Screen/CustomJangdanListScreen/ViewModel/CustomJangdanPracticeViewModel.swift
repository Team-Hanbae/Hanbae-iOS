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
    private var cancelbag: Set<AnyCancellable> = []
    
    init(templateUseCase: TemplateUseCase, metronomeOnOffUseCase: MetronomeOnOffUseCase) {
        self.templateUseCase = templateUseCase
        self.metronomeOnOffUseCase = metronomeOnOffUseCase
        
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

extension CustomJangdanPracticeViewModel {
    enum Action {
        case selectJangdan(jangdanName: String)
        case initialJangdan(jangdanName: String)
        case stopMetronome
        case createCustomJangdan(newJangdanName: String)
        case changeSoundType
        case updateCustomJangdan(newJangdanName: String?)
        case deleteCustomJangdanData(jangdanName: String)
    }
    
    func effect(action: Action) {
        switch action {
        case let .selectJangdan(jangdanName):
            self.templateUseCase.setJangdan(jangdanName: jangdanName)
        case let .initialJangdan(jangdanName):
            self.templateUseCase.setJangdan(jangdanName: jangdanName)
        case .stopMetronome:
            self.metronomeOnOffUseCase.stop()
        case let .createCustomJangdan(newJangdanName):
            try! self.templateUseCase.createCustomJangdan(newJangdanName: newJangdanName)
        case .changeSoundType:
            self.metronomeOnOffUseCase.setSoundType()
        case let .updateCustomJangdan(newJangdanName):
            self.templateUseCase.updateCustomJangdan(newJangdanName: newJangdanName)
        case let .deleteCustomJangdanData(jangdanName):
            self.templateUseCase.deleteCustomJangdan(jangdanName: jangdanName)
        }
    }
}
