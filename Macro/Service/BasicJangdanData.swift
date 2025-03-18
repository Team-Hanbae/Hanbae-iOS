//
//  BasicJangdanData.swift
//  Macro
//
//  Created by jhon on 11/18/24.
//

import Foundation

// MARK: - 기본 장단 데이터 구조체

struct BasicJangdanData {
    
    static let jinyangJanggu = JangdanEntity(
        name: "진양",
        bakCount: 72,
        daebak: 24,
        bpm: 30,
        daebakList: [
            [JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.medium, .none, .none])],
            [JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.medium, .none, .none])],
            [JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none])],
            [JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none])]
        ],
        jangdanType: .진양,
        instrument: .장구
    )
    
    static let jungmoriJanggu = JangdanEntity(
        name: "중모리",
        bakCount: 24,
        daebak: 12,
        bpm: 90,
        daebakList: [
            [JangdanEntity.Daebak(bakAccentList: [.strong, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none]), JangdanEntity.Daebak(bakAccentList: [.medium, .none])],
            [JangdanEntity.Daebak(bakAccentList: [.weak, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none])]
        ],
        jangdanType: .중모리,
        instrument: .장구
    )
    
    static let jungjungmoriJanggu = JangdanEntity(
        name: "중중모리",
        bakCount: 12,
        daebak: 4,
        bpm: 50,
        daebakList: [[
            JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .medium, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .weak, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .medium, .medium])
        ]],
        jangdanType: .중중모리,
        instrument: .장구
    )
    
    static let jajinmoriJanggu = JangdanEntity(
        name: "자진모리",
        bakCount: 12,
        daebak: 4,
        bpm: 100,
        daebakList: [[
            JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .medium, .none])
        ]],
        jangdanType: .자진모리,
        instrument: .장구
    )
    
    static let gutgeoriJanggu = JangdanEntity(
        name: "굿거리",
        bakCount: 12,
        daebak: 4,
        bpm: 50,
        daebakList: [[
            JangdanEntity.Daebak(bakAccentList: [.strong, .none, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none])
        ]],
        jangdanType: .굿거리,
        instrument: .장구
    )
    
    static let dongsalpuriJanggu = JangdanEntity(
        name: "동살풀이",
        bakCount: 8,
        daebak: 4,
        bpm: 125,
        daebakList: [[
            JangdanEntity.Daebak(bakAccentList: [.strong, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none])
        ]],
        jangdanType: .동살풀이,
        instrument: .장구
    )
    
    static let hwimoriJanggu = JangdanEntity(
        name: "휘모리",
        bakCount: 8,
        daebak: 4,
        bpm: 100,
        daebakList: [[
            JangdanEntity.Daebak(bakAccentList: [.strong, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none])
        ]],
        jangdanType: .휘모리,
        instrument: .장구
    )
    
    static let eotmoriJanggu = JangdanEntity(
        name: "엇모리",
        bakCount: 10,
        daebak: 4,
        bpm: 95,
        daebakList: [[
            JangdanEntity.Daebak(bakAccentList: [.strong, .none, .weak]),
            JangdanEntity.Daebak(bakAccentList: [.medium, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none])
        ]],
        jangdanType: .엇모리,
        instrument: .장구
    )
    
    static let semachiJanggu = JangdanEntity(
        name: "세마치",
        bakCount: 9,
        daebak: 3,
        bpm: 90,
        daebakList: [[
            JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .medium, .none])
        ]],
        jangdanType: .세마치,
        instrument: .장구
    )
    
    static let jinyangBuk = JangdanEntity(
        name: "진양",
        bakCount: 72,
        daebak: 24,
        bpm: 38,
        daebakList: [
            [JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.medium, .none, .none])],
            [JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.medium, .none, .none])],
            [JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none])],
            [JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none])]
        ],
        jangdanType: .진양,
        instrument: .북
    )
    
    static let jungmoriBuk = JangdanEntity(
        name: "중모리",
        bakCount: 24,
        daebak: 12,
        bpm: 70,
        daebakList: [
            [JangdanEntity.Daebak(bakAccentList: [.strong, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none]), JangdanEntity.Daebak(bakAccentList: [.medium, .none])],
            [JangdanEntity.Daebak(bakAccentList: [.weak, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none])]
        ],
        jangdanType: .중모리,
        instrument: .북
    )
    
    static let jungjungmoribuk = JangdanEntity(
        name: "중중모리",
        bakCount: 12,
        daebak: 4,
        bpm: 60,
        daebakList: [[
            JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .medium, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .weak, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none, .weak])
        ]],
        jangdanType: .중중모리,
        instrument: .북
    )
    
    static let jajinmoriBuk = JangdanEntity(
        name: "자진모리",
        bakCount: 12,
        daebak: 4,
        bpm: 100,
        daebakList: [[
            JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
            JangdanEntity.Daebak(bakAccentList: [.medium, .none, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.none, .medium, .none])
        ]],
        jangdanType: .자진모리,
        instrument: .북
    )
    
    static let hwimoriBuk = JangdanEntity(
        name: "휘모리",
        bakCount: 8,
        daebak: 4,
        bpm: 200,
        daebakList: [[
            JangdanEntity.Daebak(bakAccentList: [.strong, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none])
        ]],
        jangdanType: .휘모리,
        instrument: .북
    )
    
    static let eotmoriBuk = JangdanEntity(
        name: "엇모리",
        bakCount: 10,
        daebak: 4,
        bpm: 90,
        daebakList: [[
            JangdanEntity.Daebak(bakAccentList: [.strong, .none, .weak]),
            JangdanEntity.Daebak(bakAccentList: [.medium, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none])
        ]],
        jangdanType: .엇모리,
        instrument: .북
    )
    
    
    static let eotjungmoriBuk = JangdanEntity(
        name: "엇중모리",
        bakCount: 12,
        daebak: 6,
        bpm: 78,
        daebakList: [[
            JangdanEntity.Daebak(bakAccentList: [.strong, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
            JangdanEntity.Daebak(bakAccentList: [.medium, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
            JangdanEntity.Daebak(bakAccentList: [.medium, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none])
        ]],
        jangdanType: .엇중모리,
        instrument: .북
    )
    
    static let ginyeombul = JangdanEntity(
        name: "긴염불",
        bakCount: 18,
        daebak: 3,
        bpm: 25,
        daebakList: [
            [JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none, .weak])],
            [JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .weak]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none, .weak])]
        ],
        jangdanType: .긴염불,
        instrument: .장구
    )
    
    static let banyeombul = JangdanEntity(
        name: "반염불",
        bakCount: 18,
        daebak: 3,
        bpm: 65,
        daebakList: [
            [JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none, .medium])],
            [JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .weak, .weak]),
             JangdanEntity.Daebak(bakAccentList: [.none, .none, .none])]
        ],
        jangdanType: .반염불,
        instrument: .장구
    )
    
    static let all: [JangdanEntity] = [
        jinyangJanggu, jungmoriJanggu, jungjungmoriJanggu, jajinmoriJanggu, gutgeoriJanggu,
        dongsalpuriJanggu, hwimoriJanggu, eotmoriJanggu,semachiJanggu,
        jinyangBuk, jungmoriBuk, jungjungmoribuk, jajinmoriBuk,
        hwimoriBuk, eotmoriBuk, eotjungmoriBuk, ginyeombul, banyeombul
    ]
    
}
