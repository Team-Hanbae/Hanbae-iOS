//
//  HanbaeWidgetLiveActivity.swift
//  HanbaeWidget
//
//  Created by leejina on 2/16/25.
//

import ActivityKit
import WidgetKit
import SwiftUI
import AppIntents

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
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HanbaeWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            
            HStack {
                HStack {
                    VStack(spacing: 0) {
                        Text("빠르기")
                            .font(.footnote)
                            .foregroundStyle(.textSecondary)
                        Text("\(context.state.bpm)")
                            .font(.system(size: 40))
                            .fontWeight(.medium)
                    }
                    
                    Rectangle()
                        .frame(width: 1)
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 16)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Image(systemName: "waveform")
                            .font(.system(size: 17))
                        Text("\(context.state.jangdanName)")
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Button(intent: TogglePlayingIntent()) {
                        ZStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(Color.orange900)
                            Image(systemName: context.state.isPlaying ? "pause.fill": "play.fill")
                                .aspectRatio(contentMode: .fit)
                                .font(.system(size: 24))
                                .foregroundStyle(Color.buttonActive)
                        }
                    }
                    .buttonStyle(.plain)
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
                    HStack(alignment: .center, spacing: 16) {
                        VStack(spacing: 2) {
                            Spacer()
                            Text("빠르기")
                                .font(.footnote)
                                .foregroundStyle(.textSecondary)
                            Text("\(context.state.bpm)")
                                .font(.system(size: 40))
                                .fontWeight(.medium)
                                .frame(width: 76, height: 48)
                            Spacer()
                        }
                        
                        Rectangle()
                            .frame(width: 1)
                            .foregroundStyle(Color.white)
                    }
                    .frame(height: 72)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    VStack {
                        Spacer()
                        Button(intent: TogglePlayingIntent()) {
                            ZStack {
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(Color.orange900)
                                Image(systemName: context.state.isPlaying ? "pause.fill": "play.fill")
                                    .aspectRatio(contentMode: .fit)
                                    .font(.system(size: 24))
                                    .foregroundStyle(Color.buttonActive)
                            }
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                    .frame(height: 72)
                }
                
                DynamicIslandExpandedRegion(.center) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Image(systemName: "waveform")
                                .font(.system(size: 17))
                            Text("\(context.state.jangdanName)")
                                .lineLimit(1)
                        }
                        .padding(.leading, 16)
                        Spacer()
                    }
                }
            } compactLeading: {
                Image(.playState)
                    .resizable()
                    .frame(width: 22, height: 22)
                    .padding(.leading, 3)
            } compactTrailing: {
                Text("\(context.state.bpm)")
                    .padding(.trailing, 3)
            } minimal: {
                Text("\(context.state.bpm)")
            }
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
