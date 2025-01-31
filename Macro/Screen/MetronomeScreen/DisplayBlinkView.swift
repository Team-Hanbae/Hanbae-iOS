//
//  DisplayBlinkView.swift
//  Macro
//
//  Created by leejina on 1/31/25.
//

import SwiftUI

struct DisplayBlinkView: View {
    var body: some View {
        HStack(spacing: 0) {
            Image(.flash)
                .aspectRatio(contentMode: .fit)
                .padding(.trailing, 6)
            
            Text("화면 반짝임")
                .font(.title3)
                .foregroundStyle(.textSecondary)
        }
        .padding(.vertical, 12)
        .padding(.leading, 22)
        .padding(.trailing, 24)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundCard)
        )
    }
}

#Preview {
    DisplayBlinkView()
}
