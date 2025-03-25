//
//  HomeViewModel.swift
//  Macro
//
//  Created by leejina on 11/21/24.
//

import SwiftUI
import Combine

@Observable
class HomeViewModel {
    typealias JangdanSimpleType = (type: Jangdan, name: String, lastUpdate: Date)
    
    private var templateUseCase: TemplateUseCase
    private var metronomeOnOffUseCase: MetronomeOnOffUseCase
    private var dynamicIconUseCase: DynamicIconUseCase
    
    private var cancelBag: Set<AnyCancellable> = []
    
    init(templateUseCase: TemplateUseCase, metronomeOnOffUseCase: MetronomeOnOffUseCase, dynamicIconUseCase: DynamicIconUseCase) {
        self.templateUseCase = templateUseCase
        self.metronomeOnOffUseCase = metronomeOnOffUseCase
        self.dynamicIconUseCase = dynamicIconUseCase
        
        self.metronomeOnOffUseCase.firstTickPublisher.sink { [weak self] _ in
            guard let self else { return }
            self.state.isBlinking = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.linear(duration: 0.3)) {
                    self.state.isBlinking = false
                }
            }
        }
        .store(in: &cancelBag)
    }
    
    private(set) var state: State = .init()
    
    struct State {
        var customJangdanList: [JangdanSimpleType] = []
        var isBlinking: Bool = false
    }
}

extension HomeViewModel {
    enum Action {
        case changeSoundType
        case appEntered
        case fetchCustomJangdanData
    }
    
    func effect(action: Action) {
        switch action {
        case .changeSoundType:
            self.metronomeOnOffUseCase.setSoundType()
        case .appEntered:
            self.dynamicIconUseCase.setEventIconIfNeeded()
        case .fetchCustomJangdanData:
            self.state.customJangdanList = templateUseCase.allCustomJangdanTemplate.map { jangdanEntity in
                return (jangdanEntity.jangdanType, jangdanEntity.name, jangdanEntity.createdAt ?? .now)
            }.sorted {
                $0.lastUpdate > $1.lastUpdate
            }
        }
    }
}
