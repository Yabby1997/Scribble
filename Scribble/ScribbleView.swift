//
//  ScribbleView.swift
//  Scribble
//
//  Created by Seunghun on 10/15/25.
//

import SwiftUI

struct ScribbleView: View {
    let scribble: Scribble
    let strokeWidth: CGFloat
    let strokeColor: Color
    let contentInsetRatio: CGFloat
    
    init(
        scribble: Scribble,
        strokeWidth: CGFloat = 8,
        strokeColor: Color = .gray,
        contentInsetRatio: CGFloat = 0.9
    ) {
        self.scribble = scribble
        self.strokeWidth = strokeWidth
        self.strokeColor = strokeColor
        self.contentInsetRatio = contentInsetRatio
    }
    
    var body: some View {
        Canvas { context, size in
            let side = min(size.width, size.height)
            let transform = scribble.normalizingTransform(outputSide: side, insetRatio: contentInsetRatio)
            let strokeStyle = StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round)
            for stroke in scribble.strokes {
                context.stroke(
                    .init { $0.addLines(stroke.points.map { $0.applying(transform) }) },
                    with: .color(strokeColor),
                    style: strokeStyle
                )
            }
        }
        .drawingGroup()
    }
}

fileprivate extension Scribble {
    var bounds: CGRect {
        let allPoints = strokes.flatMap { $0.points }
        guard let first = allPoints.first else { return .zero }
        return allPoints.dropFirst().reduce(CGRect(origin: first, size: .zero)) { $0.union(CGRect(origin: $1, size: .zero)) }
    }

    func normalizingTransform(outputSide: CGFloat, insetRatio: CGFloat) -> CGAffineTransform {
        let bounds = bounds
        let dimension = max(bounds.width, bounds.height, 1)
        let contentSide = outputSide * insetRatio
        let scale = contentSide / dimension
        return CGAffineTransform.identity
            .translatedBy(x: (outputSide - contentSide) / 2, y: (outputSide - contentSide) / 2)
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: dimension / 2 - bounds.midX, y: dimension / 2 - bounds.midY)
    }
}
