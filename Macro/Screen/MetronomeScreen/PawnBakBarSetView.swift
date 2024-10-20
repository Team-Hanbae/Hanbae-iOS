//
//  PawnBakBarSetView.swift
//  Macro
//
//  Created by Yunki on 10/19/24.
//

import SwiftUI

struct PawnBakBarSetView: View {
    var accents: [Accent]
    var daebakIndex: Int
    var isDaebakOnly: Bool
    var isPlaying: Bool
    var activeIndex: Int?
    var tabBakBarEvent: (Int) -> Void
    
    var body: some View {
        if isDaebakOnly {
            PawnBakBarView(accent: accents[0], isActive: !isPlaying || activeIndex != nil, bakNumber: daebakIndex + 1)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .onTapGesture {
                    tabBakBarEvent(0)
                }
        } else {
            HStack(spacing: 0) {
                ForEach(accents.indices, id: \.self) { index in
                    PawnBakBarView(
                        accent: accents[index],
                        isActive: !isPlaying || index == activeIndex,
                        bakNumber: index == 0 ? daebakIndex + 1 : nil
                    )
                    .overlay {
                        // 마지막 인덱스가 아닌 경우에만 테두리 추가
                        if index > 0 {
                            HStack {
                                Rectangle()
                                    .frame(width: 1)
                                    .foregroundColor(.bakbarline)
                                
                                Spacer()
                            }
                        }
                    }
                    .onTapGesture {
                        tabBakBarEvent(index)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
    }
}

#Preview {
    PawnBakBarSetView(accents: [.strong, .medium, .weak, .none], daebakIndex: 3, isDaebakOnly: true, isPlaying: true, activeIndex: nil) {_ in}
}
