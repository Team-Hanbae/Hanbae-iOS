//
//  AudioVisualizerAnimationView.swift
//  Macro
//
//  Created by leejina on 2/17/25.
//

import SwiftUI

struct AudioVisualizerAnimationView: View {
    @Binding var isPlaying: Bool
    
    var animation: Animation {
        return .linear(duration: 0.5).repeatForever()
    }
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(spacing: 1.5) {
                bar(low: 0.1)
                    .animation(animation.speed(1.5), value: isPlaying)
                bar(low: 0.4)
                    .animation(animation.speed(1.2), value: isPlaying)
                bar(low: 0.2)
                    .animation(animation.speed(1.0), value: isPlaying)
                bar(low: 0.3)
                    .animation(animation.speed(1.7), value: isPlaying)
                bar(low: 0.5)
                    .animation(animation.speed(1.0), value: isPlaying)
                bar(low: 0.2)
                    .animation(animation.speed(1.3), value: isPlaying)
            }
            .onAppear{
                isPlaying.toggle()
            }
        }
    }
    
    func bar(low: CGFloat = 0.3, high: CGFloat = 1.0) -> some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color.white)
            .frame(width: 1.5)
            .frame(height: (isPlaying ? high * 17 : low))
            .frame(height: 17, alignment: .center)
    }
}

#Preview {
    @Previewable @State var isPlaying: Bool = true
    AudioVisualizerAnimationView(isPlaying: $isPlaying)
}
