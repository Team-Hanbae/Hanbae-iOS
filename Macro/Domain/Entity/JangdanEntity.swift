//
//  JangdanEntity.swift
//  Macro
//
//  Created by leejina on 10/1/24.
//

import Foundation

struct JangdanEntity {
    var name: String
    var createdAt: Date?
    var bakCount: Int
    var daebak: Int
    var bpm: Int
    var daebakList: [[Daebak]]
    var jangdanType: Jangdan  // 부모 장단 타입
    
    struct Daebak {
        var bakAccentList: [Accent]
    }
}
