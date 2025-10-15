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
