//
//  ShapeStyle+Extension.swift
//  Macro
//
//  Created by Yunki on 11/18/24.
//

import SwiftUICore

extension ShapeStyle {
    static var bakBarGradient: LinearGradient {
        .init(colors: [.top, .bottom], startPoint: .top, endPoint: .bottom)
    }
}

extension ShapeStyle where Self == Color {
    // MARK: - Background
    static var backgroundDefault: Color { .black13 }
    static var backgroundCard: Color { .black11 }
    static var backgroundSheet: Color { .black12 }
    static var backgroundNavigationBar: Color { .black11 }
    static var backgroundImageDefault: Color { .black10 }
    static var backgroundImageActive: Color { .orange400 }
    static var backgroundPopupMenu: Color { .black10 }
    static var backgroundBlur: Color { .black13 }
    
    // MARK: - Button
    static var buttonPrimary: Color { .black8 }
    static var buttonBPMControlDefault: Color { .black10 }
    static var buttonToggleOff: Color { .black9 }
    static var buttonToggleOn: Color { .orange600 }
    static var buttonToggleKnobInactive: Color { .black8 }
    static var buttonCancel: Color { .black8 }
    static var buttonPlayStart: Color { .black1 }
    static var buttonPlayStop: Color { .black8 }
    static var buttonActive: Color { .orange500 }
    static var buttonBPMControlActive: Color { .black8 }
    static var buttonReverse: Color { .black1 }
    
    // MARK: - BakDisplay
    static var bakBarActiveBottom: Color { .bottom }
    static var bakBarInactive: Color { .black9 }
    static var frame: Color { .black11 }
    static var bakBarLine: Color { .black13 }
    static var bakBarNumberBlack: Color { .black11 }
    static var bakBarNumberWhite: Color { .black1 }
    static var bakBarBorder: Color { .black8 }
    static var bakBarNumberGray: Color { .black9 }
    static var bub: Color { .black3 }
    static var sobakSegmentDaebak: Color { .orange500 }
    static var sobakSegmentSobak: Color { .orange300 }
    static var bakBarActiveTop: Color { .top }
    static var bakBarIndicator: Color { .orange500 }
    static var bakBarDivider: Color { .black8 }
    
    // MARK: - Text
    static var textDefault: Color { .black1 }
    static var textSecondary: Color { .black3 }
    static var textTertiary: Color { .black6 }
    static var textQuaternary: Color { .black7 }
    static var textButtonPrimary: Color { .black1 }
    static var textButtonSecondary: Color { .black2 }
    static var textBPMDefault: Color { .black4 }
    static var textBPMSearch: Color { .orange600 }
    static var textButtonCancel: Color { .black6 }
    static var textButtonEmphasis: Color { .black11 }
    
    // MARK: - ETC
    static var progressPercentage: Color { .orange500 }
    static var progressFrame: Color { .black8 }
    static var jangdanLogoBackground: Color { .orange1300 }
    static var jangdanLogoPrimary: Color { .orange700 }
}
