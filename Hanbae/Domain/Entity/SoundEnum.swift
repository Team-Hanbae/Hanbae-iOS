//
//  SoundEnum.swift
//  Macro
//
//  Created by leejina on 11/21/24.
//

enum SoundType: String, CaseIterable {
    case buk
    case clave
    case janggu
    
    var name: String {
        switch self {
        case .buk: "북"
        case .clave: "나무"
        case .janggu: "장구"
        }
    }
}
