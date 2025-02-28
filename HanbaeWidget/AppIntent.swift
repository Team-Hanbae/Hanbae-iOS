//
//  AppIntent.swift
//  HanbaeWidget
//
//  Created by leejina on 2/16/25.
//

import AppIntents

struct TogglePlayingIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Toggle Play/Pause"

    @MainActor
    func perform() async throws -> some IntentResult {
        // 현재 실행 중인 Live Activity 가져오기
        NotificationCenter.default.post(name: .playMetronome, object: nil)
        
        return .result()
    }
}
