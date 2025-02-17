//
//  LiveActivityManager.swift
//  Macro
//
//  Created by leejina on 2/17/25.
//

import Foundation
import ActivityKit

class LiveActivityManager {
    static let shared = LiveActivityManager()
    
    func startLiveActivity(bpm: Int, jangdanName: String, isPlaying: Bool) {
        if #available(iOS 16.2, *) {
            if ActivityAuthorizationInfo().areActivitiesEnabled {
                let initialContentState = HanbaeWidgetAttributes.ContentState(bpm: bpm, jangdanName: jangdanName, isPlaying: isPlaying) // 동적 컨텐츠
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
    }
    
    func endLiveActivity(bpm: Int, jangdanName: String, isPlaying: Bool) async {
        if #available(iOS 16.2, *) {
            let finalStatus = HanbaeWidgetAttributes.ContentState(bpm: bpm, jangdanName: jangdanName, isPlaying: isPlaying)
            let finalContent = ActivityContent(state: finalStatus, staleDate: nil)

            for activity in Activity<HanbaeWidgetAttributes>.activities {
                await activity.end(finalContent, dismissalPolicy: .immediate)
                print("Ending the Live Activity(Timer): \(activity.id)")
            }
        }
    }
}

//@available(iOS 16.1, *)
//@objc class LiveActivityManager: NSObject {
//    private var activity: Activity<HanbaeWidgetAttributes>?
//    
//    @objc static let shared = LiveActivityManager()
//    private init(activity: Activity<HanbaeWidgetAttributes>? = nil) {
//        self.activity = activity
//    }
//    
//    @objc func onLiveActivity() {
//        print("실행됨")
//        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
//        
//        // 정적 프로퍼티 초기화
//        let attribute = HanbaeWidgetAttributes()
//        
//        // 동적 프로퍼티 기본값 초기화
//        let state = ActivityContent(state: HanbaeWidgetAttributes.ContentState(bpm: 32, jangdanName: "자진모리", isPlaying: true), staleDate: .now)
//        
//        do {
//            // live activity 시작
//            self.activity = try Activity.request(attributes: attribute, content: state)
//            print("정상 실행됨")
//        } catch {
//            print(error)
//        }
//    }
//    
//    @objc func offLiveActivity() {
//        Task {
//            let state = ActivityContent(state: HanbaeWidgetAttributes.ContentState(bpm: 32, jangdanName: "자진모리", isPlaying: true), staleDate: .now)
//            await activity?.end(state, dismissalPolicy: .immediate)
//        }
//    }
//    
//    @objc func updateLiveActivity(emoji: String) {
//        Task {
//            let state = ActivityContent(state: HanbaeWidgetAttributes.ContentState(bpm: 32, jangdanName: "자진모리", isPlaying: true), staleDate: .now)
//            await self.activity?.update(state)
//        }
//    }
//}
