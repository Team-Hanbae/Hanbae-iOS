//
//  PawnBakBarView.swift
//  Macro
//
//  Created by Yunki on 10/19/24.
//

import SwiftUI

struct PawnBakBarView: View {
    var accent: Accent
    var isActive: Bool
    var bakNumber: Int?
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(accent > .medium
                          ? isActive ? .bakbarActive : .bakbarInactive
                          : .bakbarsetframe)
                Rectangle()
                    .fill(accent > .weak
                          ? isActive ? .bakbarActive : .bakbarInactive
                          : .bakbarsetframe)
                Rectangle()
                    .fill(accent > .none
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
