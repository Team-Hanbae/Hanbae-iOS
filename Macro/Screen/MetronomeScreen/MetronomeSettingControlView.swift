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
        HStack(spacing: 10) {
            
            Button {
                self.isSobakOn.toggle()
            } label: {
                if let sobakSegmentCount = self.viewModel.state.currentJangdanType?.sobakSegmentCount {
                    ViewSobakToggleView(isSobakOn: $isSobakOn)
                } else {
                    ListenSobakToggleView(isSobakOn: $isSobakOn)
                }
            }
            
            Button {
                self.isBlinkOn.toggle()
            } label: {
                DisplayBlinkView(isBlinkOn: $isBlinkOn)
            }
        }
        .padding(.bottom, 16)
    }
}

#Preview {
    MetronomeSettingControlView()
}
