//
//  Untitled.swift
//  Hanbae
//
//  Created by Yunki on 8/9/25.
//

import Mixpanel

enum AnalyticsEvent {
    case metronomePlay(jangdan: String,duration: Double, soundType: String)
    
    var name: String {
        switch self {
        case .metronomePlay:
            return "metronome_play"
        }
    }
    
    var properties: [String: MixpanelType]? {
        switch self {
        case let .metronomePlay(jangdan, duration, soundType):
            return [
                "jangdan": jangdan,
                "duration": duration,
                "sound_type": soundType,
                "os": "iOS"
            ]
        }
    }
}
