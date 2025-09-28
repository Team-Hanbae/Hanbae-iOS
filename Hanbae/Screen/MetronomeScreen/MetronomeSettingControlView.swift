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
            .buttonStyle(MetronomeSettingToggleButtonStyle(isOn: appState.isSobakOn))
            
            Button {
                self.viewModel.effect(action: .changeBlinkOnOff)
            } label: {
                Image(.flash)
                    .aspectRatio(contentMode: .fit)
            }
            .buttonStyle(MetronomeSettingToggleButtonStyle(isOn: appState.isBlinkOn))
            
            Button {
                self.viewModel.effect(action: .togglePrecount)
            } label: {
                Image(.precount)
                    .aspectRatio(contentMode: .fit)
            }
            .buttonStyle(MetronomeSettingToggleButtonStyle(isOn: appState.precount))
            
            Menu {
                ForEach(SoundType.allCases, id: \.rawValue) { sound in
                    Button {
                        self.appState.setInstrument(sound)
                        self.viewModel.effect(action: .changeSoundType)
                    } label: {
                        if self.appState.selectedSound == sound {
                            Image(systemName: "checkmark")
                        }
                        Text(sound.name)
                    }
                }
            } label: {
                Text(self.appState.selectedSound.name)
                    .font(.Body_R)
            }
            .buttonStyle(MetronomeSettingMenuButtonStyle())
            .frame(width: 70)
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
                    .fill(isOn ? .backgroundSubtle : .buttonDefault)
                    .strokeBorder(isOn ? .themeNormal : .buttonDefault)
                
                configuration.label
                    .font(.title3)
                    .foregroundStyle(isOn ? .themeNormal : .labelDefault)
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
                    .fill(isActive ? .backgroundSubtle : .buttonDefault)
                    .strokeBorder(isActive ? .themeNormal : .buttonDefault)
                
                configuration.label
                    .font(.title3)
                    .foregroundStyle(isActive ? .themeNormal : .labelDefault)
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
