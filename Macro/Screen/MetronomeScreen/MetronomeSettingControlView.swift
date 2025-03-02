//
//  MetronomeSettingControlView.swift
//  Macro
//
//  Created by leejina on 1/31/25.
//

import SwiftUI

struct MetronomeSettingControlView: View {
    
    @State private var viewModel: MetronomeViewModel = DIContainer.shared.metronomeViewModel
    @State private var isSobakOn: Bool = false
    @State private var isBlinkOn: Bool = false
    
    var body: some View {
        HStack(spacing: 8) {
            Button {
                self.isSobakOn.toggle()
                self.viewModel.effect(action: .changeSobakOnOff)
            } label: {
                HStack(spacing: 6) {
                    Image(self.viewModel.state.currentJangdanType?.sobakSegmentCount == nil ? .listenSobak : .viewSobak)
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(self.isSobakOn ? Color.buttonToggleOn : Color.textSecondary)
                    
                    Text(self.viewModel.state.currentJangdanType?.sobakSegmentCount == nil ? "소박 듣기" : "소박 보기")
                        .font(.title3)
                        .foregroundStyle(self.isSobakOn ? Color.buttonToggleOn : Color.textSecondary)
                }
                .padding(.vertical, 12)
                .padding(.leading, 22)
                .padding(.trailing, 24)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(self.isSobakOn ? Color.backgroundCard : Color.buttonToggleOff)
                        .strokeBorder(self.isSobakOn ? Color.buttonToggleOn : Color.buttonToggleOff)
                )
            }
            
            Button {
                self.isBlinkOn.toggle()
                self.viewModel.effect(action: .changeBlinkOnOff)
            } label: {
                HStack(spacing: 6) {
                    Image(.flash)
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(self.isBlinkOn ? Color.buttonToggleOn : Color.textSecondary)
                    
                    Text("화면 반짝임")
                        .font(.title3)
                        .foregroundStyle(self.isBlinkOn ? Color.buttonToggleOn : Color.textSecondary)
                }
                .padding(.vertical, 12)
                .padding(.leading, 22)
                .padding(.trailing, 24)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(self.isBlinkOn ? Color.backgroundCard : Color.buttonToggleOff)
                        .strokeBorder(self.isBlinkOn ? Color.buttonToggleOn : Color.buttonToggleOff)
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}

#Preview {
    MetronomeSettingControlView()
}
