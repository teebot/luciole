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
    @State private var photoThumbnail: UIImage?
    @State private var showingSettings = false

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 60) {
                // App Title
                Text("Luciole")
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .padding(.top, 80)

                Spacer()

                // Main Buttons
                HStack(spacing: 80) {
                    // Photos Button
                    HomeButton(
                        icon: "photo.on.rectangle.angled",
                        label: "Photos",
                        color: .blue,
                        thumbnail: photoThumbnail
                    ) {
                        currentScreen = .photos
                    }

                    // Music Button
                    HomeButton(
                        icon: "music.note",
                        label: "Musique",
                        color: .pink,
                        thumbnail: nil
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
                            .font(.system(size: 40))
                            .foregroundColor(.gray.opacity(0.4))
                            .padding(30)
                    }
                }
            }
        }
        .onAppear {
            loadPhotoThumbnail()
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
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 40)
                        .fill(color.opacity(0.15))
                        .frame(width: 320, height: 320)

                    if let thumbnail = thumbnail {
                        Image(uiImage: thumbnail)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 320, height: 320)
                            .clipShape(RoundedRectangle(cornerRadius: 40))
                            .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(color, lineWidth: 6)
                            )
                    } else {
                        Image(systemName: icon)
                            .font(.system(size: 120))
                            .foregroundColor(color)
                    }
                }

                Text(label)
                    .font(.system(size: 48, weight: .semibold, design: .rounded))
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
