//
//  AccentUseCase.swift
//  Macro
//
//  Created by leejina on 11/8/24.
//

import Combine

protocol AccentUseCase {
    var accentListPublisher: AnyPublisher<[[[Accent]]], Never> { get }
    func moveNextAccent(rowIndex: Int, daebakIndex: Int, sobakIndex: Int, to: Accent)
}
