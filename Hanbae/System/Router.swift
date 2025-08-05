//
//  Router.swift
//  Macro
//
//  Created by Lee Wonsun on 11/21/24.
//

import SwiftUI

enum Route: Hashable {
    case customJangdanList
    case builtInJangdanPractice(jangdanName: String)
    case jangdanTypeSelect
    case customJangdanCreate(jangdanName: String)
    case customJangdanPractice(jangdanName: String, jangdanType: String)
}

@Observable
class Router {
    var path: [Route] = .init()
    
    func view(for route: Route) -> some View {
        switch route {
        case .customJangdanList:
            return AnyView(CustomJangdanListView(viewModel: DIContainer.shared.customJangdanListViewModel))
        case let .builtInJangdanPractice(jangdanName):
            return AnyView(BuiltinJangdanPracticeView(viewModel: DIContainer.shared.builtInJangdanPracticeViewModel, jangdanName: jangdanName))
        case .jangdanTypeSelect:
            return AnyView(JangdanTypeSelectView())
        case let .customJangdanCreate(jangdanName):
            return AnyView(CustomJangdanCreateView(viewModel: DIContainer.shared.customJangdanCreateViewModel, jangdanName: jangdanName))
        case let .customJangdanPractice(jangdanName, jangdanType):
            return AnyView(CustomJangdanPracticeView(viewModel: DIContainer.shared.customJangdanPracticeViewModel, jangdanName: jangdanName, jangdanType: jangdanType))
        }
    }
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop(_ count: Int = 1) {
        path.removeLast(count)
    }
}
