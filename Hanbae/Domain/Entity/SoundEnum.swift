//
//  SoundEnum.swift
//  Macro
//
//  Created by leejina on 11/21/24.
//

enum SoundType: String, CaseIterable {
    case clave
    case buk2
    case buk1
    case janggu2
    case janggu1
    
    var name: String {
        switch self {
        case .janggu1: "장구1"
        case .janggu2: "장구2"
        case .buk1: "북1"
        case .buk2: "북2"
        case .clave: "나무"
        }
    }
    
    var fileName: String {
        switch self {
        case .janggu1: "janggu1"
        case .janggu2: "janggu"
        case .buk1: "buk1"
        case .buk2: "buk"
        case .clave: "clave"
        }
    }
}
