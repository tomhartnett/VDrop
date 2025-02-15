//
//  VDropApp.swift
//  VDrop
//
//  Created by Tom Hartnett on 2/14/25.
//

import SwiftUI

@main
struct VDropApp: App {
    @NSApplicationDelegateAdaptor private var appDelegate: MyAppDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentSize)
    }
}

class MyAppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    func applicationWillBecomeActive(_ notification: Notification) {
        if let application = notification.object as? NSApplication,
           let window = application.windows.first {
            window.standardWindowButton(.zoomButton)?.isHidden = true
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
