//
//  MetronomeSettingControlView.swift
//  Macro
//
//  Created by leejina on 1/31/25.
//

import SwiftUI

struct MetronomeSettingControlView: View {
    @State private var appState: AppState
    @State private var viewModel: MetronomeViewModel
    
    init(appState: AppState, viewModel: MetronomeViewModel) {
        self.appState = appState
        self.viewModel = viewModel
    }
    
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
                ForEach(Instrument.allCases, id: \.rawValue) { instrument in
                    Button {
                        self.appState.setInstrument(instrument)
                        self.viewModel.effect(action: .changeSoundType)
                    } label: {
                        if self.appState.selectedInstrument == instrument {
                            Image(systemName: "checkmark")
                        }
                        Text(instrument.rawValue)
                    }
                }
            } label: {
                HStack(spacing: 0) {
                    Image(systemName: "speaker.wave.2.fill")
                    
                    Text(self.appState.selectedInstrument.rawValue)
                        .font(.Body_R)
                }
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
            .frame(height: 48)
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
            .frame(height: 48)
            .onChange(of: configuration.isPressed) { _, newValue in
                isActive = newValue
            }
        }
    }
}

#Preview {
    MetronomeSettingControlView(appState: DIContainer.shared.appState, viewModel: DIContainer.shared.metronomeViewModel)
}
