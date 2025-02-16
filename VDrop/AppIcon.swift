//
//  AppIcon.swift
//  VDrop
//
//  Created by Tom Hartnett on 2/15/25.
//

import SwiftUI

// This view is just for creating a simple app icon.
// I just take a screenshot of the preview canvas and crop it.
// This view is not used by the app.
struct AppIcon: View {
    var body: some View {
        ZStack {
            Image(.customFilmBadgeArrowDown)
                .font(.system(size: 500))
                .symbolRenderingMode(.palette)
                .offset(x: 0, y: 54)
        }
        .frame(width: 1024, height: 1024)
        .border(.black)
        .padding()
        .background(.green)
    }
}

#Preview {
    AppIcon()
}
