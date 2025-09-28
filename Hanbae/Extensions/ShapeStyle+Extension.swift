//
//  ShapeStyle+Extension.swift
//  Macro
//
//  Created by Yunki on 11/18/24.
//

import SwiftUI

extension ShapeStyle {
    static var bakBarGradient: LinearGradient {
        .init(colors: [.bakBarTop, .bakBarBottom], startPoint: .top, endPoint: .bottom)
    }
}

extension ShapeStyle where Self == Color {
    // MARK: - Brand
    static var brandNormal: Color { .orange6 }
    static var brandStrong: Color { .orange7 }
    static var brandHeavy: Color { .orange8 }
    
    // MARK: - Theme
    static var themeNormal: Color { .orange6 }
    static var themeStrong: Color { .orange7 }
    static var themeHeavy: Color { .orange8 }
    
    // MARK: - Label
    static var labelDefault: Color { .neutral1 }
    static var labelPrimary: Color { .common100 }
    static var labelSecondary: Color { .neutral3 }
    static var labelTertiary: Color { .neutral6 }
    static var labelAssistive: Color { .neutral5 }
    static var labelDisable: Color { .neutral4 }
    static var labelInverse: Color { .common0 }
    
    // MARK: - Background
    static var backgroundDefault: Color { .neutral13 }
    static var backgroundElevated: Color { .neutral10 }
    static var backgroundSubtle: Color { .neutral11 }
    static var backgroundMute: Color { .neutral12 }
    static var backgroundDark: Color { .common0 }
    
    // MARK: - Metronome
    static var bakBarTop: Color { .redOrange6 }
    static var bakBarBottom: Color { .orange6 }
    static var bakBarInactive: Color { .neutral9 }
    static var bakBarLine: Color { .common0 }
    static var bakBarBorder: Color { .neutral8 }
    static var bakBarNumberDefault: Color { .common100 }
    static var bakBarNumberAlternative: Color { .neutral12 }
    static var bakBarNumberInactive: Color { .neutral9 }
    static var frame: Color { .neutral12 }
    static var sobakSegmentDaebak: Color { .orange6 }
    static var sobakSegmentSobak: Color { .orange4 }
    static var blink: Color { .orange6 }
    static var ornament: Color { .common100 }

    // MARK: - Dimmer
    static var dimmerDefault: Color { .common0.opacity(0.43) }
    static var dimmerStrong: Color { .common0.opacity(0.74) }
    static var dimmerHeavy: Color { .common0.opacity(0.88) }
    
    // MARK: - Button
    static var buttonDefault: Color { .neutral8 }
    static var buttonElevated: Color { .neutral7 }
    static var buttonSubtle: Color { .neutral9 }
    static var buttonMute: Color { .neutral10 }
    static var buttonInverse: Color { .common100 }
}
