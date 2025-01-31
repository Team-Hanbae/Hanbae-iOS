//
//  viewSobakToggleView.swift
//  Macro
//
//  Created by leejina on 11/26/24.
//

import SwiftUI

struct ViewSobakToggleView: View {
    @Binding var isSobakOn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                Image(.viewSobak)
                    .aspectRatio(contentMode: .fit)
                    .padding(.trailing, 6)
                    .padding(.vertical, 2)
                
                Text("소박 보기")
                    .font(.Title3_R)
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, 7)
        }
        .padding(.vertical, 12)
        .padding(.leading, 22)
        .padding(.trailing, 24)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(self.isSobakOn ? Color.buttonToggleOn : Color.buttonToggleOff)
        )
    }
}

#Preview {
    @Previewable @State var isSobakOn: Bool = false
    ViewSobakToggleView(isSobakOn: $isSobakOn)
}
