//
//  ScribbleListViewModel.swift
//  Scribble
//
//  Created by Seunghun on 10/15/25.
//

import Foundation
import Observation

@Observable
@MainActor
class NotebookListViewModel {
    var notebooks: [Notebook] = []
    var notebook = Notebook()
    var isPresentingEditor = false

    init() {
        load()
    }
    
    func didTapNewNotebook() {
        isPresentingEditor = true
    }
    
    func didTapNotebook(_ notebook: Notebook) {
        self.notebook = notebook
        isPresentingEditor = true
    }

    func deleteNotebook(at indexSet: IndexSet) {
        notebooks.remove(atOffsets: indexSet)
        save()
    }
    
    func onDismiss() {
        guard !notebook.isEmpty else {
            notebook = Notebook()
            return
        }

        if let existingIndex = (notebooks.firstIndex { $0.id == notebook.id }) {
            notebooks.insert(notebook, at: existingIndex)
            notebooks.remove(at: existingIndex + 1)
        } else {
            notebooks.append(notebook)
        }
        notebook = Notebook()
        save()
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(notebooks) {
            UserDefaults.standard.set(encoded, forKey: "notebooks")
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: "notebooks"),
           let decoded = try? JSONDecoder().decode([Notebook].self, from: data) {
            notebooks = decoded
        }
    }
}
