//
//  JangdanEnum.swift
//  Macro
//
//  Created by Yunki on 10/14/24.
//

import SwiftUI

enum Jangdan: String, CaseIterable {
    case 진양
    case 중모리
    case 중중모리
    case 자진모리
    case 굿거리
    case 휘모리
    case 동살풀이
    case 엇모리
    case 엇중모리
    case 세마치
    case 긴염불
    case 반염불
    
    var name: String {
        switch self {
        case .진양: return "진양"
        case .중모리: return "중모리"
        case .중중모리: return "중중모리"
        case .자진모리: return "자진모리"
        case .굿거리: return "굿거리"
        case .휘모리: return "휘모리"
        case .동살풀이: return "동살풀이"
        case .엇모리: return "엇모리"
        case .엇중모리: return "엇중모리"
        case .세마치: return "세마치"
        case .긴염불: return "긴염불"
        case .반염불: return "반염불"
        }
    }
    
    var jangdanLogoImage: Image {
        switch self {
        case .진양: return Image("Jinyang")
        case .중모리: return Image("Jungmori")
        case .중중모리: return Image("Jungjungmori")
        case .자진모리: return Image("Jajinmori")
        case .굿거리: return Image("Gutgeori")
        case .휘모리: return Image("Hwimori")
        case .동살풀이: return Image("Dongsalpuri")
        case .엇모리: return Image("Eotmori")
        case .엇중모리: return Image("Eotjungmori")
        case .세마치: return Image("Semachi")
        case .긴염불: return Image("Ginyeombul")
        case .반염불: return Image("Banyeombul")
        }
    }
    
    var sobakSegmentCount: Int? {
        switch self {
        case .진양: return 3
        case .중모리: return 2
        case .엇중모리: return 2
        default: return nil
        }
    }
    
    var bakInformation: String {
        switch self {
        case .진양: return "24박 3소박"
        case .중모리: return "12박 2소박"
        case .중중모리: return "4박 3소박"
        case .자진모리: return "4박 3소박"
        case .굿거리: return "4박 3소박"
        case .휘모리: return "4박 2소박"
        case .동살풀이: return "4박 2소박"
        case .엇모리: return "4박 3+2소박"
        case .엇중모리: return "6박 2소박"
        case .세마치: return "3박 3소박"
        case .긴염불: return "6박 3소박"
        case .반염불: return "6박 3소박"
        }
    }
}
