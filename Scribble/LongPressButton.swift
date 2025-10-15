//
//  LongPressButton.swift
//  Scribble
//
//  Created by Seunghun on 10/15/25.
//

import SwiftUI

struct LongPressButton: View {
    let image: Image
    let backgroundColor: Color
    let progressColor: Color
    let duration: TimeInterval
    let action: () -> Void

    @State private var isPressing = false
    @State private var progress: Double = 0
    @State private var timer: Timer?

    init(
        image: Image,
        backgroundColor: Color,
        progressColor: Color,
        duration: TimeInterval = 3.0,
        action: @escaping () -> Void
    ) {
        self.image = image
        self.backgroundColor = backgroundColor
        self.progressColor = progressColor
        self.duration = duration
        self.action = action
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
            image
                .foregroundColor(.white)
        }
        .aspectRatio(1, contentMode: .fit)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .trim(from: 0, to: progress)
                .stroke(progressColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
        )
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressing {
                        startPress()
                    }
                }
                .onEnded { _ in
                    endPress()
                }
        )
    }

    private func startPress() {
        isPressing = true
        progress = 0

        let interval: TimeInterval = 0.016 // ~60fps
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            progress += interval / duration

            if progress >= 1.0 {
                progress = 1.0
                endPress()
                action()
            }
        }
    }

    private func endPress() {
        isPressing = false
        timer?.invalidate()
        timer = nil

        withAnimation(.easeOut(duration: 0.2)) {
            progress = 0
        }
    }
}
