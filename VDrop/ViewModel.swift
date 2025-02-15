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

    func processFile(_ url: URL, downscalePreset: DownscalePreset?) {
        let inputFilePath = url.path(percentEncoded: false)
        let outputFilePath = buildOutputFilePath(url, isDownscaleEnabled: downscalePreset != nil)

        let arguments: [String]
        if let downscalePreset {
            // ffmpeg -i <input file> -filter:v scale=402:874 -c:a copy <output file>
            let scale = "scale=\(downscalePreset.width):\(downscalePreset.height)"
            arguments = ["-i", inputFilePath, "-filter:v", scale, "-c:a", "copy", outputFilePath]
        } else {
            // ffmpeg -i <input file> -strict -2 <output file>
            arguments = ["-i", inputFilePath, "-strict", "-2", outputFilePath]
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

    private func buildOutputFilePath(_ url: URL, isDownscaleEnabled: Bool) -> String {
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
