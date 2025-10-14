//
//  ScribbleCanvasView.swift
//  Scribble
//
//  Created by Seunghun on 10/15/25.
//

import Foundation
import PencilKit
import SwiftUI

@MainActor
struct ScribbleCanvasView: UIViewRepresentable {
    @Binding var scribble: Scribble
    @Binding var isEditing: Bool
    
    var strokeWidth: CGFloat = 8
    var strokeColor: UIColor = .black
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scribble: $scribble, isEditing: $isEditing, strokeWidth: strokeWidth, strokeColor: strokeColor)
    }
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.monoline, color: strokeColor, width: strokeWidth)
        canvasView.delegate = context.coordinator
        canvasView.drawing = scribble.pkDrawing(strokeWidth: strokeWidth, strokeColor: strokeColor)
        context.coordinator.cachedScribble = scribble
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        context.coordinator.strokeWidth = strokeWidth
        context.coordinator.strokeColor = strokeColor
        uiView.tool = PKInkingTool(.monoline, color: strokeColor, width: strokeWidth)
        if scribble != context.coordinator.cachedScribble {
            context.coordinator.isApplyingExternalUpdate = true
            uiView.drawing = scribble.pkDrawing(strokeWidth: strokeWidth, strokeColor: strokeColor)
            context.coordinator.cachedScribble = scribble
            context.coordinator.isApplyingExternalUpdate = false
        }
    }
    
    // MARK: - Coordinator
    final class Coordinator: NSObject, PKCanvasViewDelegate {
        @Binding var scribble: Scribble
        @Binding var isEditing: Bool
        
        var cachedScribble: Scribble = Scribble()
        var isApplyingExternalUpdate = false
        
        var strokeWidth: CGFloat
        var strokeColor: UIColor
        
        init(scribble: Binding<Scribble>, isEditing: Binding<Bool>, strokeWidth: CGFloat, strokeColor: UIColor) {
            _scribble = scribble
            _isEditing = isEditing
            self.strokeWidth = strokeWidth
            self.strokeColor = strokeColor
        }
        
        func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
            isEditing = true
        }
        
        func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
            isEditing = false
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            guard !isApplyingExternalUpdate else { return }
            let scribble = canvasView.drawing.scribble
            if scribble != cachedScribble {
                cachedScribble = scribble
                self.scribble = scribble
            }
        }
    }
}

extension PKDrawing {
    fileprivate var scribble: Scribble {
        .init(strokes: strokes.map { .init(points: $0.path.map { $0.location }) })
    }
}

extension Scribble {
    fileprivate func pkDrawing(strokeWidth: CGFloat, strokeColor: UIColor) -> PKDrawing {
        let ink = PKInk(.pen, color: strokeColor)
        let size = CGSize(width: strokeWidth, height: strokeWidth)
        return PKDrawing(
            strokes: strokes.map {
                PKStroke(
                    ink: ink,
                    path: .init(
                        controlPoints: $0.points.map {
                            PKStrokePoint(
                                location: $0,
                                timeOffset: 0,
                                size: size,
                                opacity: 1,
                                force: 1,
                                azimuth: .zero,
                                altitude: .zero
                            )
                        },
                        creationDate: Date()
                    ),
                    transform: .identity,
                    mask: nil
                )
            }
        )
    }
}
