//
//  PawnBakBarView.swift
//  Macro
//
//  Created by Yunki on 10/19/24.
//

import SwiftUI

fileprivate extension Accent {
    var grade: Int {
        switch self {
        case .strong: return 3
        case .medium: return 2
        case .weak: return 1
        case .none: return 0
        }
    }
}

struct PawnBakBarView: View {
    var accent: Accent
    var isActive: Bool
    var bakNumber: Int?
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(accent.grade >= Accent.strong.grade
                          ? isActive ? .bakbarActive : .bakbarInactive
                          : .bakbarsetframe)
                Rectangle()
                    .fill(accent.grade >= Accent.medium.grade
                          ? isActive ? .bakbarActive : .bakbarInactive
                          : .bakbarsetframe)
                Rectangle()
                    .fill(accent.grade >= Accent.weak.grade
                          ? isActive ? .bakbarActive : .bakbarInactive
                          : .bakbarsetframe)
            }
            
            if let bakNumber {
                Text("\(bakNumber)")
                    .font(.system(size: 32, weight: .semibold))
                    .padding(.top, 16)
                    .foregroundColor(
                        isActive
                        ? accent == .strong ? .bakbarnumberBlack : .bakbarnumberWhite
                        : accent == .strong ? .bakbarnumberBlack : .bakbarnumberGray
                    )
            }
        }
    }
}

#Preview {
    PawnBakBarView(accent: .strong, isActive: true, bakNumber: 3)
}
