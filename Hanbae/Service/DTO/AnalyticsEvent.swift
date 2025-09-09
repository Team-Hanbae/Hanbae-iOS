//
//  Untitled.swift
//  Hanbae
//
//  Created by Yunki on 8/9/25.
//

import Mixpanel

enum AnalyticsEvent {
    case metronomePlay(jangdanType: String, jangdanName: String, duration: Double, soundType: String)
    
    var name: String {
        switch self {
        case .metronomePlay:
            return "metronome_play"
        }
    }
    
    var properties: [String: MixpanelType]? {
        switch self {
        case let .metronomePlay(type, name, duration, soundType):
            return [
                "jangdan_type": type,
                "jangdan_name": name,
                "duration": duration,
                "sound_type": soundType
            ]
        }
    }
}
