//
//  NotebookEditorViewModel.swift
//  Scribble
//
//  Created by Seunghun on 10/14/25.
//

import Foundation
import Combine
import Observation

@Observable
@MainActor
class NotebookEditorViewModel {
    var notebook: Notebook
    var scribble = Scribble()
    var isEditing = false { willSet { isEditingSubject.send(newValue) } }
    private var isEditingSubject = CurrentValueSubject<Bool, Never>(false)
    private var cancellables: Set<AnyCancellable> = []

    init(notebook: Notebook) {
        self.notebook = notebook
        bind()
    }

    func bind() {
        isEditingSubject
            .removeDuplicates()
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .filter { $0 == false }
            .sink { [weak self] _ in
                self?.process()
            }
            .store(in: &cancellables)
    }

    private func process() {
        guard scribble.isEmpty == false else { return }
        notebook = notebook.appending(scribble: scribble)
        scribble = Scribble()
    }
}
