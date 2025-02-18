//
//  AppIntent.swift
//  HanbaeWidget
//
//  Created by leejina on 2/16/25.
//

import WidgetKit
import AppIntents
import ActivityKit
import Combine

//struct ConfigurationAppIntent: WidgetConfigurationIntent {
//    static var title: LocalizedStringResource { "Configuration" }
//    static var description: IntentDescription { "This is an example widget." }
//
//    // An example configurable parameter.
//    @Parameter(title: "Favorite Emoji", default: "😃")
//    var favoriteEmoji: String
//}

struct TogglePlayingIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Toggle Play/Pause"

    @MainActor
    func perform() async throws -> some IntentResult {
        // 현재 실행 중인 Live Activity 가져오기
        NotificationCenter.default.post(name: .playMetronome, object: nil)
        
        return .result()
    }
}

//@Observable
//class WidgetViewModel {
//    private var templateUseCase: TemplateUseCase
//    private var metronomeOnOffUseCase: MetronomeOnOffUseCase
//    
//    private var cancelBag: Set<AnyCancellable> = []
//    
//    init(templateUseCase: TemplateUseCase, metronomeOnOffUseCase: MetronomeOnOffUseCase) {
//        
//        self.templateUseCase = templateUseCase
//        self.metronomeOnOffUseCase = metronomeOnOffUseCase
//        
//        self.templateUseCase.currentJangdanTypePublisher.sink { [weak self] jangdanType in
//            guard let self else { return }
//            self.state.currentJangdanType = jangdanType
//        }
//        .store(in: &self.cancelBag)
//        
//        self.metronomeOnOffUseCase.isPlayingPublisher.sink { [weak self] isPlaying in
//            guard let self else { return }
//            self.state.isPlaying = isPlaying
//        }
//        .store(in: &self.cancelBag)
//    }
//    
//    private(set) var state: State = .init()
//    
//    struct State {
//        var currentJangdanName: String?
//        var currentJangdanType: Jangdan?
//        var isPlaying: Bool = false
//        var bpm: Int = 60
//    }
//}
//
//extension WidgetViewModel {
//    enum Action: Equatable {
//        case updateBPM
//        case updateJangdanName
//    }
//    
//    func effect(action: Action) {
//        switch action {
//        case .updateBPM:
//            self.
//        case .updateJangdanName:
//            
//        }
//    }
//}
