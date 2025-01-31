//
//  ListenSobakToggleView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/10/24.
//

import SwiftUI

struct ListenSobakToggleView: View {
    @Binding var isSobakOn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                Image(.listenSobak)
                    .aspectRatio(contentMode: .fit)
                    .padding(.trailing, 6)
                
                Text("소박 듣기")
                    .font(.Title3_R)
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, 9.25)
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
    ListenSobakToggleView(isSobakOn: $isSobakOn)
}
