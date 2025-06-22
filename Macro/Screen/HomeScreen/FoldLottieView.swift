//
//  FoldLottieView.swift
//  Macro
//
//  Created by leejina on 6/22/25.
//

import SwiftUI
import Lottie

struct FoldLottieView: UIViewRepresentable {
    let animationName: String
    let loopMode: LottieLoopMode
    
    init(animationName: String, loopMode: LottieLoopMode = .loop) {
        self.animationName = animationName
        self.loopMode = loopMode
    }

    func makeUIView(context: Context) -> some UIView {
        let animationView = LottieAnimationView(name: animationName)
        animationView.loopMode = loopMode
        animationView.play()
        animationView.backgroundBehavior = .pauseAndRestore
        return animationView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
