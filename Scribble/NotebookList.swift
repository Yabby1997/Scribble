//
//  ScribbleListView.swift
//  Scribble
//
//  Created by Seunghun on 10/15/25.
//

import SwiftUI

struct NotebookList: View {
    @Bindable var viewModel: NotebookListViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(viewModel.notebooks) { notebook in
                        NotebookListItem(notebook: notebook)
                            .contentTransition(.numericText())
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.didTapNotebook(notebook)
                            }
                    }
                    .onDelete(perform: viewModel.deleteNotebook(at:))
                }
                .animation(.easeInOut, value: viewModel.notebooks)
                .navigationTitle("Scribbles")

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: viewModel.didTapNewNotebook) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding()
                    }
                }
            }
            .fullScreenCover(isPresented: $viewModel.isPresentingEditor, onDismiss: viewModel.onDismiss) {
                NotebookEditor(notebook: $viewModel.notebook)
            }
        }
    }
}

struct NotebookListItem: View {
    let notebook: Notebook

    var body: some View {
        VStack {
            FlowLayout(spacing: 4) {
                ForEach(notebook.scribbles) { scribble in
                    ScribbleView(scribble: scribble, strokeWidth: 2)
                        .frame(width: 20, height: 20)
                }
            }
            .frame(height: 20)
            HStack {
                Text("Created: \(formattedDate(notebook.createdAt))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Updated: \(formattedDate(notebook.updatedAt))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
