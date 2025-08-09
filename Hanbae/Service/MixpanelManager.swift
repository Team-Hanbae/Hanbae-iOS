//
//  MixpanelManager.swift
//  Hanbae
//
//  Created by Yunki on 8/9/25.
//

import Foundation
import Mixpanel

class MixpanelManager {
    static let shared = MixpanelManager()
    
    private init() {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "MIXPANEL_TOKEN") as? String else {
            print("Mixpanel token not found in Info.plist")
            return
        }
        Mixpanel.initialize(token: token, trackAutomaticEvents: false)
    }
}

extension MixpanelManager: AnalyticsServiceInterface {
    func track(event: AnalyticsEvent) {
        switch event {
        case .metronomePlay:
            Mixpanel.mainInstance().track(event: event.name, properties: event.properties)
        }
    }
}
