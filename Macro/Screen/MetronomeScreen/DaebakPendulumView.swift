//
//  DaebakPendulumView.swift
//  Macro
//
//  Created by Yunki on 10/20/24.
//

import SwiftUI

struct DaebakPendulumView: View {
    var trigger: Bool
    
    var body: some View {
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
    DaebakPendulumView(trigger: false)
}
