//
//  ContentView.swift
//  VDrop
//
//  Created by Tom Hartnett on 2/14/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var isDownscaleEnabled = false

    @State private var selectedPreset: DownscalePreset = .iPhone16Pro

    @State private var isHover = false

    @State private var viewModel = ViewModel()

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                if viewModel.isWorking {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.extraLarge)

                } else {
                    Image(systemName: "document.badge.plus")
                        .font(.largeTitle)
                        .foregroundStyle(isHover ? .primary : .secondary)

                    Text("Drop file here")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 250, height: 125)
            .cornerRadius(12)
            .background(isHover ? Color(nsColor: .white) : Color(nsColor: .windowBackgroundColor))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.green, lineWidth: 2)
            )
            .onDrop(of: viewModel.supportedTypes, isTargeted: $isHover) { providers in
                guard let provider = providers.first,
                      let typeIdentifier = provider.registeredTypeIdentifiers.first else {
                    return false
                }

                provider.loadItem(forTypeIdentifier: typeIdentifier, options: nil) { item, error in
                    if let url = item as? URL {
                        viewModel.processFile(url, downscalePreset: isDownscaleEnabled ? selectedPreset : nil)
                    }
                }

                return true
            }

            VStack(alignment: .leading) {
                Toggle(isOn: $isDownscaleEnabled) {
                    Text("Downscale video")
                }

                Picker("", selection: $selectedPreset) {
                    Text(selectedPreset.name).tag(DownscalePreset.iPhone16Pro)
                    ForEach(DownscalePreset.devicePresets) { preset in
                        Text(preset.name).tag(preset)
                    }
                }
                .frame(width: 250)
                .disabled(!isDownscaleEnabled)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
