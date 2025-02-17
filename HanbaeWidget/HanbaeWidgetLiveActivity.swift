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
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct HanbaeWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HanbaeWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

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
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension HanbaeWidgetAttributes {
    fileprivate static var preview: HanbaeWidgetAttributes {
        HanbaeWidgetAttributes(name: "World")
    }
}

extension HanbaeWidgetAttributes.ContentState {
    fileprivate static var smiley: HanbaeWidgetAttributes.ContentState {
        HanbaeWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: HanbaeWidgetAttributes.ContentState {
         HanbaeWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: HanbaeWidgetAttributes.preview) {
   HanbaeWidgetLiveActivity()
} contentStates: {
    HanbaeWidgetAttributes.ContentState.smiley
    HanbaeWidgetAttributes.ContentState.starEyes
}
