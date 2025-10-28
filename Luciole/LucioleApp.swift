//
//  LucioleApp.swift
//  Luciole
//
//  Created for people with dementia to enjoy photos and music
//

import SwiftUI

@main
struct LucioleApp: App {
    @StateObject private var appSettings = AppSettings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appSettings)
                .statusBar(hidden: true) // Hide status bar for kiosk mode
                .persistentSystemOverlays(.hidden) // Hide system overlays on iPad
        }
    }
}
