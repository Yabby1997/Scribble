//
//  Scribble.swift
//  Scribble
//
//  Created by Seunghun on 10/15/25.
//

import Foundation

struct Stroke: Equatable, Hashable, Codable {
    let points: [CGPoint]
    var isEmpty: Bool { points.isEmpty }
    init(points: [CGPoint] = []) { self.points = points }
}

struct Scribble: Identifiable, Hashable, Equatable, Codable {
    let id: UUID
    let strokes: [Stroke]
    var isEmpty: Bool { strokes.allSatisfy { $0.isEmpty } }

    init(id: UUID = UUID(), strokes: [Stroke] = []) {
        self.id = id
        self.strokes = strokes
    }
    
    var rotated: Scribble {
        let allPoints = strokes.flatMap { $0.points }
        guard let first = allPoints.first else { return self }
        let bounds = allPoints.dropFirst().reduce(CGRect(origin: first, size: .zero)) { $0.union(CGRect(origin: $1, size: .zero)) }
        let rotatedStrokes = strokes.map { stroke in
            Stroke(
                points: stroke.points.map { point in
                    CGPoint(
                        x: 2 * bounds.midX - point.x,
                        y: 2 * bounds.midY - point.y
                    )
                }
            )
        }
        return Scribble(id: id, strokes: rotatedStrokes)
    }
}

struct Notebook: Identifiable, Hashable, Equatable, Codable {
    let id: UUID
    let createdAt: Date
    let updatedAt: Date
    let scribbles: [Scribble]
    
    var isEmpty: Bool { scribbles.allSatisfy { $0.isEmpty } }
    
    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        updatedAt: Date = .now,
        scribbles: [Scribble] = []
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.scribbles = scribbles
    }
    
    func appending(scribble: Scribble) -> Notebook {
        var newScribbles = scribbles
        newScribbles.append(scribble)
        return .init(id: id, createdAt: createdAt, updatedAt: .now, scribbles: newScribbles)
    }
}
