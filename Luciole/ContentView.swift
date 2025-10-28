//
//  ContentView.swift
//  Luciole
//
//  Main coordinator view
//

import SwiftUI

enum AppScreen {
    case home
    case photos
    case music
    case settings
}

struct ContentView: View {
    @State private var currentScreen: AppScreen = .home
    @EnvironmentObject var appSettings: AppSettings

    var body: some View {
        ZStack {
            switch currentScreen {
            case .home:
                HomeView(currentScreen: $currentScreen)
                    .transition(.opacity)
            case .photos:
                PhotoSlideshowView(currentScreen: $currentScreen)
                    .transition(.opacity)
            case .music:
                MusicPlayerView(currentScreen: $currentScreen)
                    .transition(.opacity)
            case .settings:
                SettingsView(currentScreen: $currentScreen)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: currentScreen)
    }
}
