//
//  SettingsView.swift
//  Scribble
//
//  Created by Seunghun on 10/15/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("debounceDelay") private var debounceDelay: Double = 3.0
    @AppStorage("isOppositeInput") private var isOppositeInput: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Input Wait Time: \(String(format: "%.1f", debounceDelay))s")
                            .font(.headline)
                        Slider(value: $debounceDelay, in: 1.0...10.0, step: 0.5)
                        HStack {
                            Text("1.0s")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("10.0s")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("Drawing")
                } footer: {
                    Text("Time to wait after stopping drawing before saving the scribble")
                }

                Section {
                    Toggle("Opposite Side Input", isOn: $isOppositeInput)
                } header: {
                    Text("Input Mode")
                } footer: {
                    Text("Enable this if someone is drawing from the opposite side. Scribbles will be rotated 180 degrees when saved.")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
