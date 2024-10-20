//
//  DaebakPendulumView.swift
//  Macro
//
//  Created by Yunki on 10/20/24.
//

import SwiftUI

struct DaebakPendulumView: View {
    @Binding var trigger: Bool
    var bpm: Int
    
    var body: some View {
        let interval = 60.0 / Double(bpm)
        
        ZStack(alignment: trigger ? .trailing : .leading) {
            RoundedRectangle(cornerRadius: 100)
                .foregroundStyle(.bakbarsetframe)
                .frame(height: 16)
            Circle()
                .frame(height: 16)
                .foregroundStyle(.bub)
        }
    }
}

#Preview {
    DaebakPendulumView(trigger: .constant(true), bpm: 120)
}
