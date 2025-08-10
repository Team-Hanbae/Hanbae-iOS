//
//  CustomJangdanListViewModel.swift
//  Macro
//
//  Created by Yunki on 11/21/24.
//

import SwiftUI

@Observable
class CustomJangdanListViewModel {
    typealias JangdanSimpleType = (type: Jangdan, name: String, lastUpdate: Date)
    
    private var templateUseCase: TemplateUseCase
    
    init(templateUseCase: TemplateUseCase) {
        self.templateUseCase = templateUseCase
    }
    
    struct State {
        var customJangdanList: [JangdanSimpleType] = []
    }
    
    private(set) var state: State = .init()
}

extension CustomJangdanListViewModel {
    enum Action {
        case fetchCustomJangdanData
        case deleteCustomJangdanData(jangdanName: String)
    }
    
    func effect(action: Action) {
        switch action {
        case .fetchCustomJangdanData:
            self.state.customJangdanList = templateUseCase.allCustomJangdanTemplate.map { jangdanEntity in
                return (jangdanEntity.jangdanType, jangdanEntity.name, jangdanEntity.createdAt ?? .now)
            }.sorted {
                $0.lastUpdate > $1.lastUpdate
            }
        case let .deleteCustomJangdanData(jangdanName):
            self.templateUseCase.deleteCustomJangdan(jangdanName: jangdanName)
        }
    }
}
