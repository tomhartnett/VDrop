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

    var documentImageName: String {
        if #available(macOS 15.0, *) {
            return "document.badge.plus"
        } else {
            return "document"
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 16) {
                if viewModel.isWorking {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.extraLarge)

                } else {
                    Image(systemName: documentImageName)
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)

                    if let previewDescription = viewModel.previewDescription {
                        Text(previewDescription)
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("Drop file here")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
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
                AnimatedGIFView(
                    isEnabled: $viewModel.isGIFEnabled,
                    frameRateInput: $viewModel.frameRate
                )

                DownscaleView(
                    isEnabled: $viewModel.isDownscaleEnabled,
                    widthInput: $viewModel.downscaleWidth
                )
            }
            .frame(width: 250)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
