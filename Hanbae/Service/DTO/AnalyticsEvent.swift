//
//  Untitled.swift
//  Hanbae
//
//  Created by Yunki on 8/9/25.
//

enum AnalyticsEvent {
    case metronomePlay(duration: Int, soundType: String)
    
    var name: String {
        switch self {
        case .metronomePlay:
            return "metronome_play"
        }
    }
    
    var properties: [String: Any]? {
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
