//
//  HomeViewModel.swift
//  Macro
//
//  Created by leejina on 11/21/24.
//

import SwiftUI

@Observable
class HomeViewModel {
    
    private var metronomeOnOffUseCase: MetronomeOnOffUseCase
    private var dynamicIconUseCase: DynamicIconUseCase
    
    init(metronomeOnOffUseCase: MetronomeOnOffUseCase, dynamicIconUseCase: DynamicIconUseCase) {
        self.metronomeOnOffUseCase = metronomeOnOffUseCase
        self.dynamicIconUseCase = dynamicIconUseCase
    }
}

extension HomeViewModel {
    enum Action {
        case changeSoundType
        case appEntered
    }
    
    func effect(action: Action) {
        switch action {
        case .changeSoundType:
            self.metronomeOnOffUseCase.setSoundType()
        case .appEntered:
            self.dynamicIconUseCase.setEventIconIfNeeded()
        }
    }
}
