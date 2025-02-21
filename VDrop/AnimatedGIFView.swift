//
//  AnimatedGIFView.swift
//  VDrop
//
//  Created by Tom Hartnett on 2/21/25.
//

import SwiftUI

struct AnimatedGIFView: View {
    @Binding var isEnabled: Bool

    @Binding var frameRateInput: Int

    var body: some View {
        HStack(spacing: 16) {
            Toggle(isOn: $isEnabled) {
                Text("Animated GIF")
            }

            Spacer()

            Stepper(
                value: $frameRateInput,
                in: 10...30,
                step: 1,
                label: {
                    HStack(spacing: 4) {
                        Text("fps:")
                            .foregroundStyle(.secondary)

                        Text("\(frameRateInput) ")
                            .foregroundStyle(isEnabled ? .primary : .secondary)
                            .monospaced()
                    }
                },
                onEditingChanged: { _ in }
            )
            .disabled(!isEnabled)
        }
    }
}
