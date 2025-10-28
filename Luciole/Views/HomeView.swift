//
//  HomeView.swift
//  Luciole
//
//  Home screen with large, accessible buttons for Photos and Music
//

import SwiftUI
import Photos
import MusicKit

struct HomeView: View {
    @Binding var currentScreen: AppScreen
    @EnvironmentObject var appSettings: AppSettings
    @StateObject private var weatherManager = WeatherManager()
    @State private var photoThumbnail: UIImage?
    @State private var showingSettings = false
    @State private var currentTime = ""

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            let verticalSpacing = isLandscape ? 20.0 : 60.0
            let headerPadding = isLandscape ? 20.0 : 40.0
            let headerFontSize = isLandscape ? 40.0 : 56.0
            let titleFontSize = isLandscape ? 48.0 : 72.0
            let buttonSpacing = isLandscape ? 40.0 : 80.0

            ZStack {
                Color.white
                    .ignoresSafeArea()

                VStack(spacing: verticalSpacing) {
                    // Time and Weather Header
                    HStack(alignment: .top) {
                        // Time in upper left
                        Text(currentTime)
                            .font(.system(size: headerFontSize, weight: .medium, design: .rounded))
                            .foregroundColor(.black.opacity(0.8))
                            .padding(.leading, headerPadding)
                            .padding(.top, headerPadding)

                        Spacer()

                        // Weather in upper right
                        HStack(spacing: 12) {
                            Image(systemName: weatherManager.weatherSymbol)
                                .font(.system(size: headerFontSize - 8))
                                .foregroundColor(.black.opacity(0.8))

                            Text(weatherManager.temperature)
                                .font(.system(size: headerFontSize, weight: .medium, design: .rounded))
                                .foregroundColor(.black.opacity(0.8))
                        }
                        .padding(.trailing, headerPadding)
                        .padding(.top, headerPadding)
                    }

                    // App Title
                    Text(appSettings.appTitle)
                        .font(.system(size: titleFontSize, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .padding(.top, 0)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)

                    Spacer()

                    // Main Buttons
                    HStack(spacing: buttonSpacing) {
                        // Photos Button
                        HomeButton(
                            icon: "photo.on.rectangle.angled",
                            label: "Photos",
                            color: .blue,
                            thumbnail: photoThumbnail,
                            isLandscape: isLandscape
                        ) {
                            currentScreen = .photos
                        }

                        // Music Button
                        HomeButton(
                            icon: "music.note",
                            label: "Musique",
                            color: .pink,
                            thumbnail: nil,
                            isLandscape: isLandscape
                        ) {
                            currentScreen = .music
                        }
                    }

                    Spacer()

                    // Settings Button (small, bottom corner)
                    HStack {
                        Spacer()
                        Button(action: {
                            currentScreen = .settings
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: isLandscape ? 32 : 40))
                                .foregroundColor(.gray.opacity(0.4))
                                .padding(isLandscape ? 15 : 30)
                        }
                    }
                }
            }
            .onAppear {
                loadPhotoThumbnail()
                updateTime()
                startTimeTimer()
                // Weather will be fetched automatically when location is received
            }
        }
    }

    private func updateTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        currentTime = formatter.string(from: Date())
    }

    private func startTimeTimer() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            updateTime()
        }
    }

    private func loadPhotoThumbnail() {
        guard !appSettings.selectedPhotoAlbumId.isEmpty else { return }

        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 1

        if let album = PHAssetCollection.fetchAssetCollections(
            withLocalIdentifiers: [appSettings.selectedPhotoAlbumId],
            options: nil
        ).firstObject {
            let assets = PHAsset.fetchAssets(in: album, options: fetchOptions)
            if let asset = assets.firstObject {
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 300, height: 300)
                imageManager.requestImage(
                    for: asset,
                    targetSize: targetSize,
                    contentMode: .aspectFill,
                    options: nil
                ) { image, _ in
                    photoThumbnail = image
                }
            }
        }
    }
}

struct HomeButton: View {
    let icon: String
    let label: String
    let color: Color
    let thumbnail: UIImage?
    let isLandscape: Bool
    let action: () -> Void

    var body: some View {
        let buttonSize = isLandscape ? 220.0 : 320.0
        let iconSize = isLandscape ? 80.0 : 120.0
        let labelSize = isLandscape ? 32.0 : 48.0
        let cornerRadius = isLandscape ? 30.0 : 40.0
        let spacing = isLandscape ? 10.0 : 20.0

        Button(action: action) {
            VStack(spacing: spacing) {
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(color.opacity(0.15))
                        .frame(width: buttonSize, height: buttonSize)

                    if let thumbnail = thumbnail {
                        Image(uiImage: thumbnail)
                            .resizable()
                            .scaledToFill()
                            .frame(width: buttonSize, height: buttonSize)
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            .overlay(
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .stroke(color, lineWidth: 6)
                            )
                    } else {
                        Image(systemName: icon)
                            .font(.system(size: iconSize))
                            .foregroundColor(color)
                    }
                }

                Text(label)
                    .font(.system(size: labelSize, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// Custom button style for tactile feedback
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
