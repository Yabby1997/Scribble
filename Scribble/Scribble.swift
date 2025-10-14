//
//  Scribble.swift
//  Scribble
//
//  Created by Seunghun on 10/15/25.
//

import Foundation

struct Scribble: Identifiable, Equatable, Codable {
    struct Stroke: Equatable, Codable {
        var points: [CGPoint]
        init(points: [CGPoint] = []) { self.points = points }
    }
    
    var id = UUID()
    let strokes: [Stroke]
    var isEmpty: Bool { strokes.allSatisfy { $0.points.isEmpty } }
    
    init(strokes: [Stroke] = []) {
        self.strokes = strokes
    }
}
