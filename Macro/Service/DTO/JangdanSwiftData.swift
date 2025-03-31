//
//  JangdanSwiftData.swift
//  Macro
//
//  Created by jhon on 11/13/24.
//

import SwiftData
import Foundation

// JangdanDataModel 정의
@Model
final class JangdanDataModel {
    var name: String
    var bpm: Int
    var jangdanType: String
    var daebakAccentList: [[[Int]]]
    var createdAt: Date?
    
    init(name: String, bpm: Int, jangdanType: String, daebakList: [[[Int]]], createdAt: Date? = .now) {
        self.name = name
        self.bpm = bpm
        self.jangdanType = jangdanType
        self.daebakAccentList = daebakList
        self.createdAt = createdAt
    }
}

