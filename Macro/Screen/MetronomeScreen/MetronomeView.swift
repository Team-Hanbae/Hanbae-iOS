//
//  MetronomeView.swift
//  Macro
//
//  Created by Yunki on 12/16/24.
//

import SwiftUI

struct MetronomeView: View {
    @State var viewModel: MetronomeViewModel
    
    private var jangdanName: String
    
    init(viewModel: MetronomeViewModel, jangdanName: String) {
        self.jangdanName = jangdanName
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: 1. 메트로놈 박자 표시 뷰
            VStack(spacing: 12) {
                HanbaeBoardView(
                    jangdan: viewModel.state.jangdanAccent,
                    isSobakOn: self.viewModel.state.currentJangdanType?.sobakSegmentCount == nil ? viewModel.state.isSobakOn : false,
                    isPlaying: viewModel.state.isPlaying,
                    currentRow: viewModel.state.currentRow,
                    currentDaebak: viewModel.state.currentDaebak,
                    currentSobak: viewModel.state.currentSobak
                ) { row, daebak, sobak, newAccent in
                    withAnimation {
                        viewModel.effect(action: .changeAccent(row: row, daebak: daebak, sobak: sobak, newAccent: newAccent))
                    }
                }
                if let sobakSegmentCount = self.viewModel.state.currentJangdanType?.sobakSegmentCount {
                    SobakSegmentsView(sobakSegmentCount: sobakSegmentCount, currentSobak: self.viewModel.state.currentSobak, isPlaying: self.viewModel.state.isPlaying, isSobakOn: self.viewModel.state.isSobakOn)
                }
            }
            .padding(
                self.viewModel.state.currentJangdanType?.sobakSegmentCount == nil
                ? EdgeInsets(top: 36, leading: 8, bottom: 36, trailing: 8)
                : EdgeInsets(top: 24, leading: 8, bottom: 16, trailing: 8)
            )
            
            // MARK: 2. 소박 듣기, 소박 보기 뷰
            HStack(spacing: 14) {
                MetronomeSettingControlView(appState: DIContainer.shared.appState, viewModel: self.viewModel)
                
                Spacer()
                    .frame(width: 60)
            }
            
            // MARK: 3. BPM 및 재생 조절 뷰
                MetronomeControlView()
        }
        // 빠르기 찾기 기능 비활성화 용도
        .contentShape(Rectangle())
        .onTapGesture {
            self.viewModel.effect(action: .disableEstimateBpm)
        }
        
        .task {
            self.viewModel.effect(action: .selectJangdan(selectedJangdanName: self.jangdanName))
        }
    }
}

#Preview {
    MetronomeView(viewModel: DIContainer.shared.metronomeViewModel, jangdanName: "진양")
}
