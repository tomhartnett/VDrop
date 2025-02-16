//
//  ViewModel.swift
//  VDrop
//
//  Created by Tom Hartnett on 2/15/25.
//

import Foundation
import UniformTypeIdentifiers

@Observable
final class ViewModel {
    let supportedTypes: [UTType] = [.quickTimeMovie, .mpeg4Movie]

    var isWorking = false

    var isDownscaleEnabled = false

    var scaleFactor: Double = 0.5

    func processFile(_ url: URL) {
        let inputFilePath = url.path(percentEncoded: false)
        let outputFilePath = buildOutputFilePath(url)

        let arguments: [String]
        if isDownscaleEnabled {
            // ffmpeg -i test.mov -vf "scale=iw*0.33:h=-2" test.mp4
            let scale = "scale=iw*\(String(format: "%.2f", scaleFactor)):h=-2"
            arguments = ["-i", inputFilePath, "-vf", scale, outputFilePath]
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

    private func buildOutputFilePath(_ url: URL) -> String {
        let filename = url.deletingPathExtension().lastPathComponent

        var candidateNewFilename = url.deletingLastPathComponent()
            .appendingPathComponent("\(filename).mp4")
            .path(percentEncoded: false)

        var deduplicationNumber = 1
        while FileManager.default.fileExists(atPath: candidateNewFilename) {
            candidateNewFilename = url
                .deletingLastPathComponent()
                .appendingPathComponent("\(filename) \(deduplicationNumber).mp4")
                .path(percentEncoded: false)

            deduplicationNumber += 1
        }

        return candidateNewFilename
    }
}
