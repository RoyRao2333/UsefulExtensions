//
//  LottieView.swift
//  EasyWeather
//
//  Created by Roy Rao on 2022/8/4.
//

import Cocoa
import Lottie
import SnapKit
import SwiftUI

struct LottieView: NSViewRepresentable {
    var fileName: String
    let animationView: AnimationView
    let contentMode: LottieContentMode
    let loopMode: LottieLoopMode
    let backgroundBehavior: LottieBackgroundBehavior
    let autoStart: Bool

    init(
        fileName: String,
        frameSize: CGSize,
        contentMode: LottieContentMode = .scaleAspectFit,
        loopMode: LottieLoopMode = .loop,
        backgroundBehavior: LottieBackgroundBehavior = .pauseAndRestore,
        autoStart: Bool = true
    ) {
        self.fileName = fileName
        self.contentMode = contentMode
        self.loopMode = loopMode
        self.backgroundBehavior = backgroundBehavior
        self.autoStart = autoStart
        self.animationView = AnimationView(frame: CGRect(origin: .zero, size: frameSize))
    }

    func makeNSView(context: NSViewRepresentableContext<LottieView>) -> NSView {
        NSView(frame: .zero)
    }

    func updateNSView(_ nsView: NSView, context: NSViewRepresentableContext<LottieView>) {
        nsView.subviews.forEach { $0.removeFromSuperview() }
        animationView.animation = Animation.named(fileName)
        animationView.contentMode = contentMode
        animationView.loopMode = loopMode
        animationView.backgroundBehavior = backgroundBehavior
        if autoStart {
            play()
        }
        nsView.addSubview(animationView)
    }

    func play() {
        if !animationView.isAnimationPlaying {
            animationView.play()
        }
    }

    func pause() {
        animationView.pause()
    }

    func stop() {
        animationView.stop()
    }
}
