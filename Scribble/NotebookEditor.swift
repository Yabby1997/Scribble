//
//  NotebookEditor.swift
//  Scribble
//
//  Created by Seunghun on 10/15/25.
//

import AudioToolbox
import SwiftUI

struct NotebookEditor: View {
    @Binding var notebook: Notebook
    @Environment(\.dismiss) var dismiss
    @AppStorage("debounceDelay") private var debounceDelay: Double = 3.0
    @AppStorage("isOppositeInput") private var isOppositeInput: Bool = false

    @State private var scribble = Scribble()
    @State private var isEditing = false
    @State private var debounceTask: Task<Void, Never>?

    var body: some View {
        ZStack(alignment: .topLeading) {
            FlowLayout(spacing: 4) {
                ForEach(notebook.scribbles) { scribble in
                    ScribbleView(scribble: scribble, strokeWidth: 4)
                        .frame(width: 40, height: 40)
                }
            }
            .animation(.easeInOut, value: notebook)
            ScribbleCanvasView(scribble: $scribble, isEditing: $isEditing)
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack(spacing: 24) {
                    Spacer()
                    LongPressButton(
                        image: Image(systemName: "xmark"),
                        backgroundColor: .red,
                        progressColor: .yellow,
                        duration: 1.0
                    ) {
                        dismiss()
                    }
                    .frame(width: 60, height: 60)
                    LongPressButton(
                        image: Image(systemName: "trash"),
                        backgroundColor: .orange,
                        progressColor: .yellow,
                        duration: 0.5
                    ) {
                        trashScribble()
                    }
                    .frame(width: 60, height: 60)
                    .disabled(scribble.isEmpty)
                    LongPressButton(
                        image: Image(systemName: "arrow.turn.down.left"),
                        backgroundColor: .blue,
                        progressColor: .yellow,
                        duration: 0.5
                    ) {
                        processScribble()
                    }
                    .frame(width: 60, height: 60)
                    .disabled(scribble.isEmpty)
                    Spacer()
                }
                .padding()
            }
        }
        .sensoryFeedback(.success, trigger: notebook)
        .onChange(of: notebook) { _, _ in
            AudioServicesPlaySystemSound(1169)
        }
        .onChange(of: isEditing) { _, newValue in
            debounceTask?.cancel()
            if !newValue {
                debounceTask = Task {
                    try? await Task.sleep(for: .seconds(debounceDelay))
                    guard !Task.isCancelled else { return }
                    processScribble()
                }
            }
        }
    }

    private func trashScribble() {
        debounceTask?.cancel()
        debounceTask = nil
        scribble = Scribble()
    }
    
    private func processScribble() {
        guard !scribble.isEmpty else { return }
        debounceTask?.cancel()
        debounceTask = nil
        notebook = notebook.appending(scribble: isOppositeInput ? scribble.rotated : scribble)
        scribble = Scribble()
    }
}
