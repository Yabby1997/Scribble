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
                HStack {
                    Spacer()
                    LongPressButton(
                        image: Image(systemName: "xmark"),
                        backgroundColor: .red,
                        progressColor: .yellow,
                        duration: 2.0
                    ) {
                        dismiss()
                    }
                    .frame(width: 60, height: 60)
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
                    try? await Task.sleep(for: .seconds(3))
                    guard !Task.isCancelled else { return }
                    processScribble()
                }
            }
        }
    }

    private func processScribble() {
        guard !scribble.isEmpty else { return }
        notebook = notebook.appending(scribble: scribble)
        scribble = Scribble()
    }
}
