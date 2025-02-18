//
//  HanbaeWidgetLiveActivity.swift
//  HanbaeWidget
//
//  Created by leejina on 2/16/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct HanbaeWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var bpm: Int
        var jangdanName: String
        var isPlaying: Bool
    }
    
    // Fixed non-changing properties about your activity go here!
}

struct HanbaeWidgetLiveActivity: Widget {
    
    @State var isPlaying: Bool = true
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HanbaeWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            
            HStack {
                HStack {
                    VStack(spacing: 0) {
                        Text("빠르기")
                            .font(.footnote)
                        Text("\(context.state.bpm)")
                            .font(.system(size: 40))
                    }
                    
                    Rectangle()
                        .frame(width: 1)
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 16)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        AudioVisualizerAnimationView(isPlaying: $isPlaying)
                        Text("\(context.state.jangdanName)")
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(Color.orange900)
                        Image(systemName: context.state.isPlaying ? "pause.fill": "play.fill")
                            .aspectRatio(contentMode: .fit)
                            .font(.system(size: 24))
                            .foregroundStyle(Color.buttonActive)
                    }
                    .onTapGesture {
                        self.isPlaying.toggle()
//                        Task {
//                            let intent = TogglePlayingIntent(isPlying: <#T##IntentParameter<Bool>#>)
//                            _ = try? await intent.perform()
//                        }
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 28)
            }
            .frame(height: 90)
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .foregroundStyle(Color.white)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.bpm)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.bpm)")
            } minimal: {
                Text("T \(context.state.bpm)")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension HanbaeWidgetAttributes {
    fileprivate static var preview: HanbaeWidgetAttributes {
        HanbaeWidgetAttributes()
    }
}

extension HanbaeWidgetAttributes.ContentState {
    fileprivate static var jangdanData: HanbaeWidgetAttributes.ContentState {
        HanbaeWidgetAttributes.ContentState(bpm: 32, jangdanName: "자진모리(흥부가)", isPlaying: true)
    }
}

#Preview("Notification", as: .content, using: HanbaeWidgetAttributes.preview) {
    HanbaeWidgetLiveActivity()
} contentStates: {
    HanbaeWidgetAttributes.ContentState.jangdanData
}
