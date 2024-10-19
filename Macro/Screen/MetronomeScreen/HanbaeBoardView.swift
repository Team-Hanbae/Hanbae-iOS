//
//  HanbaeBoardView.swift
//  Macro
//
//  Created by Yunki on 10/19/24.
//

import SwiftUI

struct HanbaeBoardView: View {
    var jangdan: [[Accent]]
    var isSobakOn: Bool
    var isPlaying: Bool
    var currentIndex: Int
    var tabBakBarEvent: (Int, Int) -> Void
    
    var body: some View {
        Grid(verticalSpacing: 4) {
            GridRow {
                ForEach(jangdan.indices, id: \.self) { daebakIndex in
                    
                    PawnBakBarSetView(
                        accents: jangdan[daebakIndex],
                        daebakIndex: daebakIndex,
                        isDaebakOnly: !isSobakOn,
                        isPlaying: isPlaying,
                        activeIndex: calculateActiveIndex(daebakIndex: daebakIndex, currentIndex: currentIndex)
                    ) { sobak in
                        tabBakBarEvent(daebakIndex, sobak)
                    }
                    .gridCellColumns(jangdan[daebakIndex].count)
                }
            }
        }
    }
}

extension HanbaeBoardView {
    private func calculateActiveIndex(daebakIndex: Int, currentIndex: Int) -> Int? {
        var beforeCurrentDaebakCount = 0
        for i in 0..<daebakIndex {
            beforeCurrentDaebakCount += jangdan[i].count
        }
        if beforeCurrentDaebakCount..<beforeCurrentDaebakCount + jangdan[daebakIndex].count ~= currentIndex {
            return currentIndex - beforeCurrentDaebakCount
        }
        return nil
    }
}

#Preview {
    HanbaeBoardView(
        jangdan: [[.strong, .weak],
                  [.weak, .medium, .medium],
                  [.weak, .weak],
                  [.weak, .weak, .weak]], isSobakOn: true, isPlaying: true, currentIndex: 3) {_,_ in }
}
