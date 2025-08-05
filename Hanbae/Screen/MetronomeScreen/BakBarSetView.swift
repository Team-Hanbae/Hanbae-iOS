//
//  BakBarSetView.swift
//  Macro
//
//  Created by Yunki on 10/19/24.
//

import SwiftUI

struct BakBarSetView: View {
    var accents: [Accent]
    var daebakIndex: Int
    var isDaebakOnly: Bool
    var isPlaying: Bool
    var activeIndex: Int?
    var tabBakBarEvent: (Int, Accent) -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(isDaebakOnly ? 0..<1 : accents.indices, id: \.self) { index in
                BakBarView(
                    accent: accents[index],
                    isPlaying: isPlaying,
                    isActive: !isPlaying || (isDaebakOnly ? activeIndex != nil : index == activeIndex),
                    bakNumber: index == 0 ? daebakIndex + 1 : nil
                ) { newAccent in
                    tabBakBarEvent(index, newAccent)
                }
                .overlay {
                    // 마지막 인덱스가 아닌 경우에만 테두리 추가
                    if index > 0 {
                        HStack {
                            Rectangle()
                                .frame(width: 1)
                                .foregroundColor(.bakBarLine)
                            
                            Spacer()
                        }
                    }
                }
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 4)
                .stroke(.bakBarBorder, lineWidth: 2)
        }
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

#Preview {
    BakBarSetView(accents: [.strong, .medium, .weak, .none], daebakIndex: 3, isDaebakOnly: false, isPlaying: true, activeIndex: nil) {_, _ in}
}
