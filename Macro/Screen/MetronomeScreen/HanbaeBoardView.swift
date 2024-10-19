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
        Grid(horizontalSpacing: 0) {
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
                    
                    if daebakIndex < jangdan.count - 1 {
                        VStack {
                            Rectangle()
                                .frame(width: 1, height: 12)
                                .foregroundStyle(.bakbardivider)
                                .offset(y: -16)
                            
                            Spacer()
                            
                            Rectangle()
                                .frame(width: 1, height: 12)
                                .foregroundStyle(.bakbardivider)
                                .offset(y: 16)
                        }
                        .frame(width: 4)
                    }
                }
            }
        }
        .padding(.vertical, 16)
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
