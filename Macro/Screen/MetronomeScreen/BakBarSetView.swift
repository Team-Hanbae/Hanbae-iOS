//
//  BakBarSetView.swift
//  Macro
//
//  Created by jhon on 10/14/24.
//

import SwiftUI

// RhythmCase 정의
enum RhythmCase {
    case basicCase // 중모리, 중중모리, 굿거리
    case dongsalpuri
    case hwimori
    case eotmori // 엇모리 대박 크기: 3/2/3/2 패턴
    case eotjungmori
    case semachi
    
    // 대박 크기 반환 (너비 * 높이)
    func daebakSize(forIndex index: Int) -> (width: CGFloat, height: CGFloat) {
        switch self {
        case .basicCase:
            return (width: 91.5, height: 280) // 대박 너비 91.5, 높이 280
        case .dongsalpuri:
            return (width: 91.5, height: 280) // 대박 너비 91.5, 높이 280
        case .hwimori:
            return (width: 186.5, height: 280) // 대박 너비 186.5, 높이 280
        case .eotmori:
            // 엇모리 대박 크기 패턴: 3/2/3/2
            return (index % 2 == 0) ? (width: 109.5, height: 280) : (width: 73, height: 280)
        case .eotjungmori:
            return (width: 59.5, height: 280) // 대박 너비 59.5, 높이 280
        case .semachi:
            return (width: 123, height: 280) // 대박 너비 123, 높이 280
        }
    }
    
    // 소박 크기 반환 (너비 * 높이, 높이에 280을 곱함), 소박이 없는 경우 nil
    func sobakSize() -> (width: CGFloat, height: CGFloat)? {
        switch self {
        case .basicCase:
            return (width: 91.5/3, height: 280) // 소박 너비 30.42, 높이 280
        case .dongsalpuri:
            return (width: 91.5/2, height: 280) // 소박 너비 45.62, 높이 280
        case .hwimori:
            return (width: 186.5/2, height: 280) // 소박 너비 93.25, 높이 280
        case .eotmori:
            return (width: 36.5, height: 280) // 소박 너비 36.5, 높이 280
        case .eotjungmori:
            return nil // 소박 없음
        case .semachi:
            return (width: 41, height: 280) // 소박 너비 41, 높이 280
        }
    }
}


// RhythmCase를 대박과 소박 개수로 결정하는 함수 추가
func determineRhythmCase(daebakCount: Int, bakCount: Int) -> RhythmCase {
    switch (daebakCount, bakCount) {
    case (4, 12):
        return .basicCase // 중모리, 중중모리, 굿거리
    case (4, 8):
        return .dongsalpuri
    case (2, 4):
        return .hwimori
    case (4, 10):
        return .eotmori
    case (6, _):
        return .eotjungmori // 소박이 없는 경우도 있음
    case (3, 9):
        return .semachi
    default:
        return .basicCase // 기본 케이스로 fallback
    }
}


// BakBarSetView: 대박과 소박을 그리는 뷰
struct BakBarSetView: View {
    @State var viewModel: MetronomeViewModel
    
    var body: some View {
        // 대박과 소박 개수로 리듬 케이스 결정
        let rhythmCase = determineRhythmCase(daebakCount: viewModel.state.daebakCount, bakCount: viewModel.state.bakCount)
        
        HStack(spacing: 1) {
            if viewModel.state.isSobakOn {
                // 소박을 반복하여 그리기
                ForEach(viewModel.state.jangdanAccent.indices, id: \.self) { daebakIndex in
                    let daebak = viewModel.state.jangdanAccent[daebakIndex]
                    
                    HStack(spacing: 0) { // 소박들이 한 대박 안에 붙어서 렌더링
                        ForEach(daebak.indices, id: \.self) { sobakIndex in
                            let currentSobakIndex = (daebakIndex * daebak.count) + sobakIndex
                            let isCurrentBeat = viewModel.state.isPlaying && viewModel.state.currentIndex == currentSobakIndex
                            
                            BakBarView(
                                currentAccent: daebak[sobakIndex], // 소박의 강세 적용
                                bakInt: sobakIndex == 0 ? daebakIndex + 1 : 0, // 첫 소박에만 숫자를 표시
                                barHeight: rhythmCase.sobakSize()?.height ?? 280, // 소박 높이
                                barWidth: rhythmCase.sobakSize()?.width ?? 30, // 소박 너비
                                
                                // 재생 중일 때와 아닐 때의 색상 분기 처리
                                barColor: !viewModel.state.isPlaying ? .bakbarActive : (isCurrentBeat ? .bakbarActive : .bakbarInactive),
                                strongAccentIntColor: !viewModel.state.isPlaying ? .bakbarnumberBlack : (isCurrentBeat ? .bakbarnumberBlack : .bakbarnumberBlack),
                                elseAccentIntColor: !viewModel.state.isPlaying ? .bakbarnumberWhite : (isCurrentBeat ? .bakbarnumberWhite  : .bakbarnumberGray),
                                accent: {
                                    viewModel.effect(action: .changeAccent(daebak: daebakIndex, sobak: sobakIndex))
                                }
                            )
                            .overlay(
                                // 마지막 인덱스가 아닌 경우에만 테두리 추가
                                sobakIndex != daebak.count - 1 ?
                                Rectangle()
                                    .frame(width: 1)
                                    .foregroundColor(.black) : nil,
                                alignment: .trailing
                            )
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 4)) // 소박도 둥근 모서리 적용
                    
                    // 대박 사이에 디바이더 추가
                    if daebakIndex != viewModel.state.jangdanAccent.count - 1 {
                        VStack(spacing: 285) {
                            Divider()
                                .frame(width: 1, height: 12)
                                .background(Color.gray)
                            
                            Divider()
                                .frame(width: 1, height: 12)
                                .background(Color.gray)
                        }
                    }
                }
            } else {
                // 대박을 반복하여 그리기
                ForEach(viewModel.state.jangdanAccent.indices, id: \.self) { daebakIndex in
                    let size = rhythmCase.daebakSize(forIndex: daebakIndex)
                    let daebak = viewModel.state.jangdanAccent[daebakIndex]
                    let isCurrentBeat = viewModel.state.isPlaying && viewModel.state.currentIndex == daebakIndex
                    
                    BakBarView(
                        currentAccent: daebak[0],
                        bakInt: daebakIndex + 1,
                        barHeight: size.height,
                        barWidth: size.width,
                        
                        barColor: !viewModel.state.isPlaying ? .bakbarActive : (isCurrentBeat ? .bakbarActive : .bakbarInactive),
                        strongAccentIntColor: !viewModel.state.isPlaying ? .bakbarnumberBlack : (isCurrentBeat ? .bakbarnumberBlack : .bakbarnumberBlack),
                        elseAccentIntColor: !viewModel.state.isPlaying ? .bakbarnumberWhite : (isCurrentBeat ? .bakbarnumberWhite  : .bakbarnumberGray),
                        accent: {viewModel.effect(action: .changeAccent(daebak: daebakIndex, sobak: 0))}
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    //                        .padding(.trailing, 1)
                    
                    // 대박 사이에 디바이더 추가
                    if daebakIndex != viewModel.state.jangdanAccent.count - 1 {
                        VStack(spacing: 285) {
                            Divider()
                                .frame(width: 1, height: 12)
                                .background(Color.gray)
                            
                            Divider()
                                .frame(width: 1, height: 12)
                                .background(Color.gray)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 8)
    }
}

// 프리뷰 설정
struct BakBarSetView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MetronomeViewModel()
        viewModel.effect(action: .selectJangdan(jangdan: .굿거리))
        
        return BakBarSetView(
            viewModel: viewModel
        )
    }
}
