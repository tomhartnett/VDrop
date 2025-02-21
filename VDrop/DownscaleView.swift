//
//  DownscaleView.swift
//  VDrop
//
//  Created by Tom Hartnett on 2/20/25.
//

import SwiftUI

struct DownscaleView: View {
    @Binding var isEnabled: Bool

    @Binding var widthInput: Int

    @State private var numberFormatter: NumberFormatter = {
        var nf = NumberFormatter()
        nf.numberStyle = .none
        nf.minimum = NSNumber(value: 100)
        nf.maximum = NSNumber(value: 5000)
        return nf
    }()

    var body: some View {
        HStack {
            Toggle(isOn: $isEnabled) {
                Text("Downscale width")
            }

            Spacer()

            TextField("400", value: $widthInput, formatter: numberFormatter)
                .frame(width: 50)
                .multilineTextAlignment(.trailing)
                .monospaced()
                .disabled(!isEnabled)

            Stepper(value: $widthInput, step: 1, label: {
                EmptyView()
            }, onEditingChanged: { _ in })
        }
    }
}

#Preview {
    DownscaleView(isEnabled: .constant(true), widthInput: .constant(1000))
        .frame(width: 250, height: 100)
        .padding()
}
