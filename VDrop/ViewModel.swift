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
            // ffmpeg -i <input file> -filter:v scale=402:874 -c:a copy <output file>
            // ffmpeg -i test.mov -vf "scale=iw*0.33:h=-2" test.mp4
            let scale = "scale=iw*\(String(format: "%.2f", scaleFactor)):h=-2"
            arguments = ["-i", inputFilePath, "-vf", scale, outputFilePath]
        } else {
            // ffmpeg -i <input file> -strict -2 <output file>
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
        let filePath = url.path(percentEncoded: false)
        let filename = url.lastPathComponent

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 'at' h.mm.ss a"
        var newFilename = "video \(formatter.string(from: Date()))"

        if isDownscaleEnabled {
            newFilename.append(" - downscaled")
        }

        newFilename.append(".mp4")

        return filePath.replacing(filename, with: newFilename)
    }
}
