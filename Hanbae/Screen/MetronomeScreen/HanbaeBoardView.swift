//
//  HanbaeBoardView.swift
//  Macro
//
//  Created by Yunki on 10/19/24.
//

import SwiftUI

struct HanbaeBoardView: View {
    var jangdan: [[[Accent]]]
    var isSobakOn: Bool
    var isPlaying: Bool
    var currentRow: Int
    var currentDaebak: Int
    var currentSobak: Int
    var disabled: Bool
    var tabBakBarEvent: (Int, Int, Int, Accent) -> Void
    
    // 대박 누적합 미리 연산
    private var prefixSumList: [Int] {
        guard !self.jangdan.isEmpty else { return [] }
        var sumList: [Int] = .init(repeating: 0, count: self.jangdan.count)
        for row in 1..<self.jangdan.count {
            sumList[row] = sumList[row - 1] + jangdan[row].count
        }
        return sumList
    }
    
    var body: some View {
        Grid(horizontalSpacing: 4, verticalSpacing: 8) {
            ForEach(jangdan.indices, id: \.self) { row in
                GridRow {
                    ForEach(jangdan[row].indices, id: \.self) { daebakIndex in
                        BakBarSetView(
                            accents: jangdan[row][daebakIndex],
                            daebakIndex: daebakIndex + prefixSumList[row],
                            isDaebakOnly: !isSobakOn,
                            isPlaying: isPlaying,
                            activeIndex: !disabled && currentRow == row && currentDaebak == daebakIndex ? currentSobak : nil
                        ) { sobakIndex, newAccent in
                            tabBakBarEvent(row, daebakIndex, sobakIndex, newAccent)
                        }
                        .gridCellColumns(jangdan[row][daebakIndex].count)
                    }
                }
            }
        }
    }
}

#Preview {
    HanbaeBoardView(
        jangdan: [[[.strong, .weak],
                   [.weak, .medium, .medium],
                   [.weak, .weak],
                   [.weak, .weak, .weak]]], isSobakOn: true, isPlaying: true, currentRow: 0, currentDaebak: 1, currentSobak: 2, disabled: false) { _, _, _, _ in }
}
