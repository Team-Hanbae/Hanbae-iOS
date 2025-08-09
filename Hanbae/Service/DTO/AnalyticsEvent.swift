//
//  Untitled.swift
//  Hanbae
//
//  Created by Yunki on 8/9/25.
//

import Mixpanel

enum AnalyticsEvent {
    case metronomePlay(duration: Double, soundType: String)
    
    var name: String {
        switch self {
        case .metronomePlay:
            return "metronome_play"
        }
    }
    
    var properties: [String: MixpanelType]? {
        switch self {
        case let .metronomePlay(duration, soundType):
            return [
                "duration": duration,
                "sound_type": soundType,
                "os": "iOS"
            ]
        }
    }
}
