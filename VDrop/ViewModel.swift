//
//  ViewModel.swift
//  VDrop
//
//  Created by Tom Hartnett on 2/15/25.
//

import AVFoundation
import Foundation
import UniformTypeIdentifiers
import SwiftUI

@Observable
final class ViewModel {
    let supportedTypes: [UTType] = [.quickTimeMovie, .mpeg4Movie]

    var isHover = false

    var isWorking = false

    var isDownscaleEnabled = false

    var isGIFEnabled = false

    var frameRate = 10

    var scaleFactor: Double = 0.5

    var previewDescription: String?

    func processFile(_ url: URL) {
        let inputFilePath = url.path(percentEncoded: false)
        let outputFilePath = buildOutputFileURL(url).path(percentEncoded: false)

        let arguments: [String]
        var filterArguments = ""

        if isGIFEnabled {
            filterArguments.append("fps=\(frameRate)")
        }

        if isDownscaleEnabled {
            if !filterArguments.isEmpty {
                filterArguments.append(",")
            }

            // scale=trunc(iw*0.33/2)*2:trunc(ih*0.33/2)*2
            let scaleFactorString = String(format: "%.2f", scaleFactor)
            filterArguments.append("scale=trunc(iw*\(scaleFactorString)/2)*2:trunc(ih*\(scaleFactorString)/2)*2")
        }

        if !filterArguments.isEmpty {
            // ffmpeg -i test.mov -vf "fps=10,scale=trunc(iw*0.33/2)*2:trunc(ih*0.33/2)*2" test.mp4
            arguments = ["-i", inputFilePath, "-vf", filterArguments, outputFilePath]
        } else {
            // ffmpeg -i <input file> <output file>
            arguments = ["-i", inputFilePath, outputFilePath]
        }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/opt/homebrew/bin/ffmpeg")
        process.arguments = arguments

        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = outputPipe

        do {
            isWorking = true

            try process.run()
            process.waitUntilExit()

            // TODO: implement proper error-handling
            // Message errors back to UI; currently not shown.
            if process.terminationStatus == 0 {
                print("FFmpeg command completed successfully.")
            } else {
                print("FFmpeg command failed with status \(process.terminationStatus).")
            }
        } catch {
            print("Error running FFmpeg: \(error.localizedDescription)")
        }

        isWorking = false
    }

    private func buildOutputFileURL(_ url: URL) -> URL {
        let filename = url.deletingPathExtension().lastPathComponent
        let fileExtension = isGIFEnabled ? "gif" : "mp4"

        var candidateNewFilename = url.deletingLastPathComponent()
            .appendingPathComponent("\(filename).\(fileExtension)")

        var deduplicationNumber = 1
        while FileManager.default.fileExists(atPath: candidateNewFilename.path(percentEncoded: false)) {
            candidateNewFilename = url
                .deletingLastPathComponent()
                .appendingPathComponent("\(filename) \(deduplicationNumber).\(fileExtension)")

            deduplicationNumber += 1
        }

        return candidateNewFilename
    }

    private func inspectFile(_ url: URL) async {
        let asset = AVURLAsset(url: url)

        let tracks = try? await asset.loadTracks(withMediaType: .video)

        guard let track = tracks?.first else {
            return
        }

        let properties: (CGSize, CGAffineTransform)? = try? await track.load(.naturalSize, .preferredTransform)

        if let size = properties?.0 {

            let filename = buildOutputFileURL(url).lastPathComponent
            let width: String
            let height: String
            if isDownscaleEnabled {
                width = String(format: "%.0f", size.width * scaleFactor)
                height = String(format: "%.0f", size.height * scaleFactor)
            } else {
                width = String(format: "%.0f", size.width)
                height = String(format: "%.0f", size.height)
            }

            DispatchQueue.main.async { [weak self] in
                self?.previewDescription = "\(filename) - \(width) × \(height)"
            }
        }
    }
}

extension ViewModel: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        guard !isWorking else { return false }

        isHover = false
        previewDescription = nil

        guard let provider = info.itemProviders(for: supportedTypes).first,
              let typeIdentifier = provider.registeredTypeIdentifiers.first else {
            return false
        }

        provider.loadItem(forTypeIdentifier: typeIdentifier) { [weak self] item, error in
            if let url = item as? URL {
                self?.processFile(url)
            }
        }
        return true
    }

    func dropEntered(info: DropInfo) {
        guard !isWorking else { return }

        isHover = true

        guard let provider = info.itemProviders(for: supportedTypes).first,
              let typeIdentifier = provider.registeredTypeIdentifiers.first else {
            return
        }

        provider.loadItem(forTypeIdentifier: typeIdentifier, options: nil) { [weak self] item, error in
            if let url = item as? URL {
                Task {
                    await self?.inspectFile(url)
                }
            }
        }
    }

    func dropExited(info: DropInfo) {
        guard !isWorking else { return }

        isHover = false
        previewDescription = nil
    }

    func validateDrop(info: DropInfo) -> Bool {
        !isWorking
    }
}

// This silences `Capture of non-sendable type in @Sendable closure`.
// Probably not a "real" solution long-term.
extension ViewModel: @unchecked Sendable {}
