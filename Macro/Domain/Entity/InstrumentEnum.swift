//
//  InstrumentEnum.swift
//  Macro
//
//  Created by jhon on 11/14/24.
//

enum Instrument: String {
    case 북
    case 장구
}

extension Instrument {
    var defaultJangdans: [Jangdan] {
        switch self {
        case .북: return [.진양, .중모리, .중중모리, .자진모리, .엇모리, .엇중모리, .휘모리]
        case .장구: return [.진양, .중모리, .중중모리, .자진모리, .굿거리, .동살풀이, .세마치, .엇모리, .휘모리, .긴염불, .반염불]
        }
    }
}
