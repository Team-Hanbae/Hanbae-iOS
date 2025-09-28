//
//  SobakSegmentView.swift
//  Macro
//
//  Created by leejina on 11/19/24.
//

import SwiftUI

struct SobakSegmentsView: View {
    var sobakSegmentCount: Int
    var currentSobak: Int
    var isPlaying: Bool
    var isSobakOn: Bool
    
    var body: some View {
        HStack(spacing: 1) {
            ForEach(0..<sobakSegmentCount, id: \.self) { index in
                Rectangle()
                    .foregroundStyle(segmentStyle(for: index))
            }
        }
        .background(isSobakOn ? .bakBarBorder : .bakBarLine)
        .frame(height: 20)
        .overlay {
            if isSobakOn {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.bakBarBorder, lineWidth: 2)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
    
    private func segmentStyle(for index: Int) -> AnyShapeStyle {
        guard isSobakOn, isPlaying, currentSobak == index else {
            return AnyShapeStyle(.frame)
        }
        return AnyShapeStyle(index == 0 ? .sobakSegmentDaebak : .sobakSegmentSobak)
    }
}

#Preview {
    SobakSegmentsView(sobakSegmentCount: 3, currentSobak: 2, isPlaying: true, isSobakOn: false)
}
