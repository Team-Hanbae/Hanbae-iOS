//
//  MacroApp.swift
//  Macro
//
//  Created by Yunki on 9/21/24.
//

import SwiftUI

@main
struct MacroApp: App {
    var homeViewModel: HomeViewModel = DIContainer.shared.homeViewModel
    
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: self.homeViewModel, router: DIContainer.shared.router, appState: DIContainer.shared.appState)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.homeViewModel.effect(action: .appEntered)
                    }
                }
        }
    }
}
