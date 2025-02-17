//
//  HanbaeWidgetBundle.swift
//  HanbaeWidget
//
//  Created by leejina on 2/16/25.
//

import WidgetKit
import SwiftUI

@main
struct HanbaeWidgetBundle: WidgetBundle {
    var body: some Widget {
        HanbaeWidget()
        HanbaeWidgetControl()
        HanbaeWidgetLiveActivity()
    }
}
