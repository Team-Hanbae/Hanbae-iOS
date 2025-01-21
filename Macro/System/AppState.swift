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
        
        self.numberOfCreatedCustomJangdan = UserDefaults.standard.integer(forKey: "numberOfCreatedCustomJangdan")
        self.numberOfEnteredJangdan = UserDefaults.standard.integer(forKey: "numberOfEnteredJangdan")
    }
    
    // 최초실행여부
    private(set) var didLaunchedBefore: Bool
    
    // 선택된 악기
    private(set) var selectedInstrument: Instrument
    
    // 비프음 여부
    private(set) var isBeepSound: Bool
    
    // 커스텀장단 생성 횟수
    private(set) var numberOfCreatedCustomJangdan: Int
    
    // 장단 진입 횟수
    private(set) var numberOfEnteredJangdan: Int
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
    
    func increaseCreatedCustomJangdan() {
        self.numberOfCreatedCustomJangdan += 1
        UserDefaults.standard.set(self.numberOfCreatedCustomJangdan ,forKey: "numberOfCreatedCustomJangdan")
    }
    
    func increaseEnteredJangdan() {
        self.numberOfEnteredJangdan += 1
        UserDefaults.standard.set(self.numberOfEnteredJangdan ,forKey: "numberOfEnteredJangdan")
    }
}
