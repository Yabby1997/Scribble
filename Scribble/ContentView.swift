//
//  ContentView.swift
//  Scribble
//
//  Created by Seunghun on 10/14/25.
//

import SwiftUI

struct ContentView: View {
    @Bindable var viewModel = NotebookListViewModel()

    var body: some View {
        NotebookList(viewModel: viewModel)
    }
}

#Preview {
    ContentView()
}
