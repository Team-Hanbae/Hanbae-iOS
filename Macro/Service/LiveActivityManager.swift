//
//  LiveActivityManager.swift
//  Macro
//
//  Created by leejina on 2/17/25.
//

import Foundation
import ActivityKit
import Combine

protocol WidgetManager {
    func startLiveActivity()
    func updateLiveActivity() async
    func endLiveActivity() async
}

class LiveActivityManager {
    
    private var jangdanRepository: JangdanRepository
    private var metronomeOnOffUseCase: MetronomeOnOffUseCase
    private var tempoUseCase: TempoUseCase
    
    private var cancelBag: Set<AnyCancellable> = []
    
    private var bpm: Int
    private var jangdanName: String
    private var isPlaying: Bool
    
    init(jangdanRepository: JangdanRepository, metronomeOnOffUseCase: MetronomeOnOffUseCase, tempoUseCase: TempoUseCase) {
        self.jangdanRepository = jangdanRepository
        self.metronomeOnOffUseCase = metronomeOnOffUseCase
        self.tempoUseCase = tempoUseCase
        
        self.bpm = 0
        self.jangdanName = "자진모리"
        self.isPlaying = false
        
        self.jangdanRepository.jangdanPublisher.sink { [weak self] jangdan in
            guard let self else { return }
            self.bpm = jangdan.bpm
            self.jangdanName = jangdan.name
            Task {
                await self.updateLiveActivity()
            }
        }
        .store(in: &self.cancelBag)
        
        self.metronomeOnOffUseCase.isPlayingPublisher.sink { [weak self] isPlaying in
            guard let self else { return }
            self.isPlaying = isPlaying
            
            if isPlaying && Activity<HanbaeWidgetAttributes>.activities.isEmpty {
                self.startLiveActivity()
            }
            
            Task {
                await self.updateLiveActivity()
            }
        }
        .store(in: &self.cancelBag)
        
        NotificationCenter.default.publisher(for: .playMetronome)
            .sink { _ in
                if self.isPlaying {
                    self.metronomeOnOffUseCase.stop()
                } else {
                    self.metronomeOnOffUseCase.play()
                }
            }
            .store(in: &cancelBag)
    }
}

extension LiveActivityManager: WidgetManager {
    func startLiveActivity() {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            let initialContentState = HanbaeWidgetAttributes.ContentState(bpm: self.bpm, jangdanName: self.jangdanName, isPlaying: self.isPlaying) // 동적 컨텐츠
            let activityAttributes = HanbaeWidgetAttributes() // 정적 컨텐츠
            let activityContent = ActivityContent(state: initialContentState, staleDate: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!)
            
            do {
                let activity = try Activity.request(attributes: activityAttributes, content: activityContent)
                print("Requested Lockscreen Live Activity(Timer) \(String(describing: activity.id)).")
            } catch (let error) {
                print("Error requesting Lockscreen Live Activity(Timer) \(error.localizedDescription).")
            }
        }
    }
    
    func endLiveActivity() async {
        let finalStatus = HanbaeWidgetAttributes.ContentState(bpm: self.bpm, jangdanName: self.jangdanName, isPlaying: self.isPlaying)
        let finalContent = ActivityContent(state: finalStatus, staleDate: nil)
        
        for activity in Activity<HanbaeWidgetAttributes>.activities {
            await activity.end(finalContent, dismissalPolicy: .immediate)
            print("Ending the Live Activity(Timer): \(activity.id)")
        }
    }
    
    func updateLiveActivity() async {
        let status = HanbaeWidgetAttributes.ContentState(bpm: self.bpm, jangdanName: self.jangdanName, isPlaying: self.isPlaying)
        let content = ActivityContent(state: status, staleDate: nil)
        for activity in Activity<HanbaeWidgetAttributes>.activities {
            await activity.update(content)
        }
    }
}
