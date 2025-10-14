//
//  ContentView.swift
//  Scribble
//
//  Created by Seunghun on 10/14/25.
//

import AudioToolbox
import SwiftUI

// TODO: Add clear and save
struct ContentView: View {
    @Bindable private var viewModel = ScribbleViewModel()

    var body: some View {
        ZStack(alignment: .topLeading) {
            FlowLayout(spacing: 4) {
                ForEach(viewModel.scribbles) { scribble in
                    ScribbleView(scribble: scribble, strokeWidth: 4)
                        .frame(width: 40, height: 40)
                }
            }
            .animation(.easeInOut, value: viewModel.scribbles)
            ScribbleCanvasView(scribble: $viewModel.scribble, isEditing: $viewModel.isEditing)
                .ignoresSafeArea()
        }
        .sensoryFeedback(.success, trigger: viewModel.scribbles)
        .onChange(of: viewModel.scribbles) { _, _ in
            AudioServicesPlaySystemSound(1169)
        }
    }
}

#Preview {
    ContentView()
}
