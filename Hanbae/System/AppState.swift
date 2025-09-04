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
        
        let instrument = UserDefaults.standard.string(forKey: "selectedSound") ?? "janggu1"
        self.selectedSound = SoundType(rawValue: instrument) ?? .janggu1
        
        UserDefaults.standard.removeObject(forKey: "isBeepSound")
        
        self.numberOfCreatedCustomJangdan = UserDefaults.standard.integer(forKey: "numberOfCreatedCustomJangdan")
        self.numberOfEnteredJangdan = UserDefaults.standard.integer(forKey: "numberOfEnteredJangdan")
        self.newFeatureModal = UserDefaults.standard.bool(forKey: "newFeatureModal")
        self.newFeatureBadge = UserDefaults.standard.bool(forKey: "newFeatureBadge")
        self.precount = UserDefaults.standard.bool(forKey: "precount")
    }
    
    // 최초실행여부
    private(set) var didLaunchedBefore: Bool
    
    // 선택된 악기
    private(set) var selectedSound: SoundType
    
    // 커스텀장단 생성 횟수
    private(set) var numberOfCreatedCustomJangdan: Int
    
    // 장단 진입 횟수
    private(set) var numberOfEnteredJangdan: Int
    
    // 신규 기능 알림
    private(set) var newFeatureModal: Bool
    private(set) var newFeatureBadge: Bool
    
    // Precount
    private(set) var precount: Bool
}

extension AppState {
    func appLaunched() {
        self.didLaunchedBefore = true
        UserDefaults.standard.set(true, forKey: "didLaunchedBefore")
    }
    
    func setInstrument(_ sound: SoundType) {
        self.selectedSound = sound
        UserDefaults.standard.set(sound.rawValue, forKey: "selectedSound")
    }
    
    func increaseCreatedCustomJangdan() {
        self.numberOfCreatedCustomJangdan += 1
        UserDefaults.standard.set(self.numberOfCreatedCustomJangdan ,forKey: "numberOfCreatedCustomJangdan")
    }
    
    func increaseEnteredJangdan() {
        self.numberOfEnteredJangdan += 1
        UserDefaults.standard.set(self.numberOfEnteredJangdan ,forKey: "numberOfEnteredJangdan")
    }
    
    func checkNewFeatureModal() {
        self.newFeatureModal = true
        UserDefaults.standard.set(true, forKey: "newFeatureModal")
    }
    
    func checkNewFeatureBadge() {
        self.newFeatureBadge = true
        UserDefaults.standard.set(true, forKey: "newFeatureBadge")
    }
    
    func togglePrecount() {
        self.precount.toggle()
        UserDefaults.standard.set(self.precount, forKey: "newFeatureBadge")
    }
}
