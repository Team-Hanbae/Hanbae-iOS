//
//  BakBarView.swift
//  Macro
//
//  Created by Yunki on 10/19/24.
//

import SwiftUI

struct BakBarView: View {
    var accent: Accent
    var accentHeight: Int {
        switch self.accent {
        case .strong:
            return 3
        case .medium:
            return 2
        case .weak:
            return 1
        case .none:
            return 0
        }
    }
    var isPlaying: Bool
    var isActive: Bool
    var bakNumber: Int?
    var updateAccent: (Accent) -> Void
    
    @State private var startLocation: CGPoint? = nil
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .foregroundStyle(isPlaying && isActive ? .orange.opacity(0.5) : .frame)
                    
                    Path { path in
                        for i in 1..<3 {
                            let y = CGFloat(i) * (geo.size.height / 3) - 0.5
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: geo.size.width, y: y))
                        }
                    }
                    .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round, dash: [4, 4]))
                    .foregroundColor(.bakBarDivider)
                    
                    Rectangle()
                        .frame(height: CGFloat((geo.size.height / 3) * Double(accentHeight)))
                        .foregroundStyle(isActive
                                         ? .bakBarGradient
                                         : LinearGradient(colors: [.bakBarInactive], startPoint: .top, endPoint: .bottom))
                }
                
                if let bakNumber {
                    Text("\(bakNumber)")
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.top, 20)
                        .foregroundColor(
                            isActive
                            ? .bakBarNumberWhite
                            : accent == .strong ? .bakBarNumberBlack : geo.size.height < 100 && accent == .medium ? .bakBarNumberBlack : .bakBarNumberGray
                        )
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if startLocation == nil {
                            startLocation = gesture.location
                        }
                    }
                    .onEnded { gesture in
                        guard let startLocation else { return }
                        
                        // 드래그 작동하게 설정한 거리
                        let limit = geo.size.height / 9
                        let dragDistance = gesture.location.y - startLocation.y
                        
                        if abs(dragDistance) > limit {
                            let adjustment = dragDistance > 0 ? 1 : -1
                            let newGrade = self.accent.rawValue + adjustment
                            
                            if 0...3 ~= newGrade {
                                updateAccent(Accent(rawValue: newGrade) ?? .none)
                            }
                        }
                        
                        // 드래그 완료 후 초기화
                        self.startLocation = nil
                    }
            )
            .onTapGesture {
                updateAccent(self.accent.nextAccent())
            }
        }
    }
}

#Preview {
    BakBarView(accent: .medium, isPlaying: false, isActive: true, bakNumber: 3) {_ in }
}
