//
//  AppState.swift
//  Macro
//
//  Created by Yunki on 11/24/24.
//

import SwiftUI

@Observable
class AppState {
    
    init() {
#if DEBUG
        self.didLaunchedBefore = false
#else
        self.didLaunchedBefore = UserDefaults.standard.bool(forKey: "didLaunchedBefore")
#endif
        
        let instrument = UserDefaults.standard.string(forKey: "selectedInstrument") ?? "장구"
        self.selectedInstrument = Instrument(rawValue: instrument) ?? .장구
        
        self.isBeepSound = UserDefaults.standard.bool(forKey: "isBeepSound")
    }
    
    // 최초실행여부
    private(set) var didLaunchedBefore: Bool
    
    // 선택된 악기
    private(set) var selectedInstrument: Instrument
    
    // 비프음 여부
    private(set) var isBeepSound: Bool
    
}

extension AppState {
    func appLaunched() {
        self.didLaunchedBefore = true
        UserDefaults.standard.set(true, forKey: "didLaunchedBefore")
    }
    
    func setInstrument(_ instrument: Instrument) {
        self.selectedInstrument = instrument
        UserDefaults.standard.set(instrument.rawValue, forKey: "selectedInstrument")
    }
    
    func toggleBeepSound() {
        self.isBeepSound.toggle()
        UserDefaults.standard.set(self.isBeepSound, forKey: "isBeepSound")
    }
}
