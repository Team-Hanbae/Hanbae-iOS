//
//  BasicJangdanData.swift
//  Macro
//
//  Created by jhon on 11/18/24.
//

import Foundation

// MARK: - 기본 장단 데이터 구조체

struct BasicJangdanData {
    
    // 민속악 장단
    static let jinyang = JangdanEntity(
        name: "진양",
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
        jangdanType: .진양
    )
    
    static let jungmori = JangdanEntity(
        name: "중모리",
        bpm: 90,
        daebakList: [
            [JangdanEntity.Daebak(bakAccentList: [.strong, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none]), JangdanEntity.Daebak(bakAccentList: [.medium, .none])],
            [JangdanEntity.Daebak(bakAccentList: [.weak, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none]), JangdanEntity.Daebak(bakAccentList: [.weak, .none])]
        ],
        jangdanType: .중모리
    )
    
    static let jungjungmori = JangdanEntity(
        name: "중중모리",
        bpm: 50,
        daebakList: [[
            JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .medium, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .weak, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .medium, .medium])
        ]],
        jangdanType: .중중모리
    )
    
    static let jajinmori = JangdanEntity(
        name: "자진모리",
        bpm: 100,
        daebakList: [[
            JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .medium, .none])
        ]],
        jangdanType: .자진모리
    )
    
    static let gutgeori = JangdanEntity(
        name: "굿거리",
        bpm: 50,
        daebakList: [[
            JangdanEntity.Daebak(bakAccentList: [.strong, .none, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none])
        ]],
        jangdanType: .굿거리
    )
    
    static let dongsalpuri = JangdanEntity(
        name: "동살풀이",
        bpm: 125,
        daebakList: [[
            JangdanEntity.Daebak(bakAccentList: [.strong, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none])
        ]],
        jangdanType: .동살풀이
    )
    
    static let hwimori = JangdanEntity(
        name: "휘모리",
        bpm: 100,
        daebakList: [[
            JangdanEntity.Daebak(bakAccentList: [.strong, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none])
        ]],
        jangdanType: .휘모리
    )
    
    static let eotmori = JangdanEntity(
        name: "엇모리",
        bpm: 95,
        daebakList: [[
            JangdanEntity.Daebak(bakAccentList: [.strong, .none, .weak]),
            JangdanEntity.Daebak(bakAccentList: [.medium, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none])
        ]],
        jangdanType: .엇모리
    )
    
    static let semachi = JangdanEntity(
        name: "세마치",
        bpm: 90,
        daebakList: [[
            JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none, .medium]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .medium, .none])
        ]],
        jangdanType: .세마치
    )
    
    static let eotjungmori = JangdanEntity(
        name: "엇중모리",
        bpm: 78,
        daebakList: [[
            JangdanEntity.Daebak(bakAccentList: [.strong, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
            JangdanEntity.Daebak(bakAccentList: [.medium, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
            JangdanEntity.Daebak(bakAccentList: [.medium, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none])
        ]],
        jangdanType: .엇중모리
    )
    
    static let jwajilgut = JangdanEntity(
        name: "사물놀이 - 좌질굿",
        bpm: 100,
        daebakList: [
            [JangdanEntity.Daebak(bakAccentList: [.weak, .medium]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .medium]),
             JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .medium]),
             JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .medium])],
            [JangdanEntity.Daebak(bakAccentList: [.weak, .medium]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .medium]),
             JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .medium]),
             JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .medium])],
            [JangdanEntity.Daebak(bakAccentList: [.weak, .medium]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .medium]),
             JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .medium]),
             JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .medium])],
            [JangdanEntity.Daebak(bakAccentList: [.strong, .none, .weak, .weak, .none])],
            [JangdanEntity.Daebak(bakAccentList: [.strong, .none, .weak, .weak, .none])],
        ],
        jangdanType: .좌질굿
    )
    
    
    // 정악 장단
    static let sangnyeongsan = JangdanEntity(
        name: "상령산, 중령산",
        bpm: 3,
        daebakList: [
            [JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none, .none, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none, .none, .none])],
            [JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .medium, .none, .none, .none, .weak])],
        ],
        jangdanType: .상령산
    )
    
    static let seryeongsan = JangdanEntity(
        name: "세령산, 가락덜이",
        bpm: 5,
        daebakList: [
            [JangdanEntity.Daebak(bakAccentList: [.strong, .none, .weak]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none])],
            [JangdanEntity.Daebak(bakAccentList: [.weak, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none, .none])],
        ],
        jangdanType: .세령산
    )
    
    static let taryeong = JangdanEntity(
        name: "타령, 군악",
        bpm: 35,
        daebakList: [[
            JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]),
            JangdanEntity.Daebak(bakAccentList: [.medium, .none, .none]),
            JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
            JangdanEntity.Daebak(bakAccentList: [.none, .none, .none]),
        ]],
        jangdanType: .타령
    )
    
    static let chwita = JangdanEntity(
        name: "취타",
        bpm: 60,
        daebakList: [
            [JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none])],
            [JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none])],
            [JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.none, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none])],
        ],
        jangdanType: .취타
    )
    
    static let jeolhwa = JangdanEntity(
        name: "절화",
        bpm: 60,
        daebakList: [
            [JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none])],
            [JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.none, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none])],
        ],
        jangdanType: .절화
    )
    
    static let ginyeombul = JangdanEntity(
        name: "긴염불",
        bpm: 25,
        daebakList: [
            [JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none, .weak])],
            [JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.strong, .weak, .weak]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none, .weak])]
        ],
        jangdanType: .긴염불
    )
    
    static let banyeombul = JangdanEntity(
        name: "반염불",
        bpm: 65,
        daebakList: [
            [JangdanEntity.Daebak(bakAccentList: [.strong, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.medium, .none, .medium])],
            [JangdanEntity.Daebak(bakAccentList: [.weak, .none, .none]),
             JangdanEntity.Daebak(bakAccentList: [.weak, .weak, .weak]),
             JangdanEntity.Daebak(bakAccentList: [.none, .none, .none])]
        ],
        jangdanType: .반염불
    )
    
    static let all: [JangdanEntity] = [
        // 민속악
        jinyang,
        jungmori,
        jungjungmori,
        jajinmori,
        gutgeori,
        dongsalpuri,
        hwimori,
        eotmori,
        semachi,
        eotjungmori,
        jwajilgut,
        // 정악
        sangnyeongsan,
        seryeongsan,
        taryeong,
        chwita,
        jeolhwa,
        ginyeombul,
        banyeombul
    ]
}
