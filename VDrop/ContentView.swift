//
//  ContentView.swift
//  VDrop
//
//  Created by Tom Hartnett on 2/14/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var viewModel = ViewModel()

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 16) {
                if viewModel.isWorking {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.extraLarge)

                } else {
                    if #available(macOS 15.0, *) {
                        Image(systemName: "document.badge.plus")
                            .font(.largeTitle)
                            .foregroundStyle(viewModel.isHover ? .primary : .secondary)
                    } else {
                        Image(systemName: "document")
                            .font(.largeTitle)
                            .foregroundStyle(viewModel.isHover ? .primary : .secondary)
                    }

                    Text("Drop file here")
                        .font(.title2)
                        .foregroundStyle(viewModel.isHover ? .primary : .secondary)
                }
            }
            .frame(width: 250, height: 125)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.green.opacity(viewModel.isHover || viewModel.isWorking ? 1 : 0.5),
                            lineWidth: viewModel.isHover ? 4 : 2)
            )
            .onDrop(of: viewModel.supportedTypes, delegate: viewModel)

            VStack(alignment: .leading) {
                HStack(spacing: 16) {
                    Toggle(isOn: $viewModel.isGIFEnabled) {
                        Text("Animated GIF")
                    }

                    Spacer()

                    Stepper(
                        value: $viewModel.frameRate,
                        in: 10...30,
                        step: 1,
                        label: {
                            HStack(spacing: 4) {
                                Text("fps:")
                                    .foregroundStyle(.secondary)

                                Text("\(viewModel.frameRate) ")
                                    .foregroundStyle(viewModel.isGIFEnabled ? .primary : .secondary)
                                    .monospaced()
                            }
                        },
                        onEditingChanged: { _ in }
                    )
                    .disabled(!viewModel.isGIFEnabled)
                }

                HStack(spacing: 16) {
                    Toggle(isOn: $viewModel.isDownscaleEnabled) {
                        Text("Downscale video")
                    }

                    Spacer()

                    Stepper(
                        value: $viewModel.scaleFactor,
                        in: 0.25...0.99,
                        step: 0.01,
                        label: {
                            Text(String(format: "%.0f%%", viewModel.scaleFactor * 100))
                                .foregroundStyle(viewModel.isDownscaleEnabled ? .primary : .secondary)
                                .monospaced()
                        },
                        onEditingChanged: { _ in }
                    )
                    .disabled(!viewModel.isDownscaleEnabled)
                }

                VStack(alignment: .center) {
                    Text(viewModel.previewDescription ?? " ")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(width: 250)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
