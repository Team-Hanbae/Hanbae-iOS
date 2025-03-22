//
//  MetronomeSettingControlView.swift
//  Macro
//
//  Created by leejina on 1/31/25.
//

import SwiftUI

struct MetronomeSettingControlView: View {
    @State private var viewModel: MetronomeViewModel = DIContainer.shared.metronomeViewModel
    
    var body: some View {
        HStack(spacing: 8) {
            Button {
                self.viewModel.effect(action: .changeSobakOnOff)
            } label: {
                Image(self.viewModel.state.currentJangdanType?.sobakSegmentCount == nil ? .listenSobak : .viewSobak)
                    .aspectRatio(contentMode: .fit)
            }
            .buttonStyle(MetronomeSettingToggleButtonStyle())
            
            Button {
                self.viewModel.effect(action: .changeBlinkOnOff)
            } label: {
                Image(.flash)
                    .aspectRatio(contentMode: .fit)
            }
            .buttonStyle(MetronomeSettingToggleButtonStyle())
            
            Menu {
                Text("장구")
                Text("북")
                Text("나무")
            } label: {
                Image(systemName: "speaker.wave.2.fill")
            }
            .buttonStyle(MetronomeSettingMenuButtonStyle())
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}

extension MetronomeSettingControlView {
    private struct MetronomeSettingToggleButtonStyle: ButtonStyle {
        @State var isOn: Bool = false
        
        func makeBody(configuration: Configuration) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isOn ? Color.backgroundCard : Color.buttonToggleOff)
                    .strokeBorder(isOn ? Color.buttonToggleOn : Color.buttonToggleOff)
                
                configuration.label
                    .font(.title3)
                    .foregroundStyle(isOn ? Color.buttonToggleOn : Color.textSecondary)
            }
            .frame(height: 56)
            .onChange(of: configuration.isPressed) { _, newValue in
                if newValue {
                    isOn.toggle()
                }
            }
        }
    }
    
    private struct MetronomeSettingMenuButtonStyle: ButtonStyle {
        @State var isActive: Bool = false
        
        func makeBody(configuration: Configuration) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isActive ? Color.backgroundCard : Color.buttonToggleOff)
                    .strokeBorder(isActive ? Color.buttonToggleOn : Color.buttonToggleOff)
                
                configuration.label
                    .font(.title3)
                    .foregroundStyle(isActive ? Color.buttonToggleOn : Color.textSecondary)
            }
            .frame(height: 56)
            .onChange(of: configuration.isPressed) { _, newValue in
                isActive = newValue
            }
        }
    }
}

#Preview {
    MetronomeSettingControlView()
}
