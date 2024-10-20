//
//  JangdanEntity.swift
//  Macro
//
//  Created by leejina on 10/1/24.
//

struct JangdanEntity {
    var name: String
    var bakCount: Int
    var daebak: Int 
    var bpm: Int
    var daebakList: [Daebak]
    
    struct Daebak {
        var bakAccentList: [Accent]
    }
}

enum Accent {
    case strong
    case medium
    case weak
    case none
    
    func nextAccent() -> Accent {
        switch self {
        case .strong: return .medium
        case .medium: return .weak
        case .weak: return .none
        case .none: return .strong
        }
    }
}

extension Accent: Comparable {
    static func < (lhs: Accent, rhs: Accent) -> Bool {
        switch (lhs, rhs) {
        case (.none, .strong), (.weak, .strong), (.medium, .strong): return true
        case (.none, .medium), (.weak, .medium): return true
        case (.none, .weak): return true
        default: return false
        }
    }
}
