//
//  ContentView.swift
//  VDrop
//
//  Created by Tom Hartnett on 2/14/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var isHover = false

    @State private var viewModel = ViewModel()

    var body: some View {
        VStack(spacing: 16) {
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
                        .foregroundStyle(isHover ? .primary : .secondary)
                }
            }
            .frame(width: 250, height: 125)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.green.opacity(isHover || viewModel.isWorking ? 1 : 0.5),
                            lineWidth: isHover ? 4 : 2)
            )
            .onDrop(of: viewModel.supportedTypes, isTargeted: $isHover) { providers in
                guard let provider = providers.first,
                      let typeIdentifier = provider.registeredTypeIdentifiers.first else {
                    return false
                }

                provider.loadItem(forTypeIdentifier: typeIdentifier, options: nil) { item, error in
                    if let url = item as? URL {
                        viewModel.processFile(url)
                    }
                }

                return true
            }

            HStack(spacing: 16) {
                Toggle(isOn: $viewModel.isDownscaleEnabled) {
                    Text("Downscale video")
                }

                Stepper(
                    value: $viewModel.scaleFactor,
                    in: 0.25...0.99,
                    step: 0.01,
                    label: {
                        Text(String(format: "%.0f%%", viewModel.scaleFactor * 100))
                    },
                    onEditingChanged: { _ in })
                .disabled(!viewModel.isDownscaleEnabled)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
