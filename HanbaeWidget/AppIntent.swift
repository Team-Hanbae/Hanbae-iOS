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

struct TogglePlayingIntent: AppIntent {
    

    static var title: LocalizedStringResource = "Toggle Play/Pause"
    
    @Parameter(title: "하이")
    var isPlying: Bool

    func perform() async throws -> some IntentResult {
        // 현재 실행 중인 Live Activity 가져오기
        let activities = Activity<HanbaeWidgetAttributes>.activities
        for activity in activities {
            // 현재 상태 가져오기
            let currentState = activity.content
            let updatedState = HanbaeWidgetAttributes.ContentState(
                bpm: currentState.state.bpm,
                jangdanName: currentState.state.jangdanName,
                isPlaying: !currentState.state.isPlaying // 현재 상태를 반대로 변경
            )
            // Live Activity 업데이트
            await activity.update(using: updatedState)
        }
        
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
