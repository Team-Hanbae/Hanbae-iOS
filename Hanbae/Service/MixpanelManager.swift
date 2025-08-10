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
        #if DEBUG
        guard let token = Bundle.main.object(forInfoDictionaryKey: "MIXPANEL_DEV_TOKEN") as? String else {
            print("Mixpanel token not found in Info.plist")
            return
        }
        #else
        var isTestFlight: Bool {
            guard let path = Bundle.main.appStoreReceiptURL?.path else { return false }
            return path.contains("sandboxReceipt")
        }
        print("MIXPANEL_\(isTestFlight ? "DEV" : "PROD")_TOKEN")
        guard let token = Bundle.main.object(forInfoDictionaryKey: "MIXPANEL_\(isTestFlight ? "DEV" : "PROD")_TOKEN") as? String else {
            print("Mixpanel token not found in Info.plist")
            return
        }
        #endif
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
