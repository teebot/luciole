//
//  MusicPlayerView.swift
//  Luciole
//
//  Music player with large, accessible controls
//

import SwiftUI
import MusicKit

struct MusicPlayerView: View {
    @Binding var currentScreen: AppScreen
    @EnvironmentObject var appSettings: AppSettings
    @StateObject private var musicManager = MusicManager.shared

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            let verticalSpacing = isLandscape ? 15.0 : 50.0
            let artworkSize = isLandscape ? 180.0 : 350.0
            let artworkBgSize = isLandscape ? 220.0 : 400.0
            let iconSize = isLandscape ? 80.0 : 150.0
            let titleSize = isLandscape ? 28.0 : 42.0
            let artistSize = isLandscape ? 22.0 : 32.0
            let controlSpacing = isLandscape ? 30.0 : 60.0
            let volumeSpacing = isLandscape ? 50.0 : 100.0
            let backButtonSize = isLandscape ? 60.0 : 80.0
            let backPadding = isLandscape ? 20.0 : 40.0
            let bottomPadding = isLandscape ? 15.0 : 40.0

            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [.pink.opacity(0.3), .purple.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: verticalSpacing) {
                    Spacer()

                    // Album Art or Music Icon
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: artworkBgSize, height: artworkBgSize)

                        if let artwork = musicManager.currentSong?.artwork {
                            ArtworkImage(artwork, width: artworkSize, height: artworkSize)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "music.note")
                                .font(.system(size: iconSize))
                                .foregroundColor(.white)
                        }
                    }

                    // Song Information
                    VStack(spacing: 10) {
                        Text(musicManager.currentSong?.title ?? "Aucune musique")
                            .font(.system(size: titleSize, weight: .bold))
                            .foregroundColor(.black)
                            .lineLimit(1)

                        Text(musicManager.currentSong?.artistName ?? "")
                            .font(.system(size: artistSize, weight: .medium))
                            .foregroundColor(.black.opacity(0.7))
                            .lineLimit(1)
                    }
                    .frame(maxWidth: 800)

                    Spacer()

                    // Playback Controls
                    HStack(spacing: controlSpacing) {
                        // Previous Button
                        ControlButton(icon: "backward.fill", size: isLandscape ? 50 : 70, isLandscape: isLandscape) {
                            musicManager.skipToPrevious()
                        }

                        // Play/Pause Button
                        ControlButton(
                            icon: musicManager.isPlaying ? "pause.fill" : "play.fill",
                            size: isLandscape ? 70 : 100,
                            isLandscape: isLandscape
                        ) {
                            if musicManager.isPlaying {
                                musicManager.pause()
                            } else {
                                musicManager.play()
                            }
                        }

                        // Next Button
                        ControlButton(icon: "forward.fill", size: isLandscape ? 50 : 70, isLandscape: isLandscape) {
                            musicManager.skipToNext()
                        }
                    }

                    // Volume Controls
                    HStack(spacing: volumeSpacing) {
                        VolumeButton(icon: "speaker.minus.fill", isLandscape: isLandscape) {
                            musicManager.decreaseVolume()
                        }

                        VolumeButton(icon: "speaker.plus.fill", isLandscape: isLandscape) {
                            musicManager.increaseVolume()
                        }
                    }
                    .padding(.bottom, bottomPadding)

                    Spacer()
                }

                // Back Button
                VStack {
                    HStack {
                        Button(action: {
                            musicManager.stop()
                            currentScreen = .home
                        }) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.system(size: backButtonSize))
                                .foregroundColor(.white.opacity(0.8))
                                .shadow(color: .black.opacity(0.3), radius: 10)
                        }
                        .padding(backPadding)
                        Spacer()
                    }
                    Spacer()
                }
            }
            .onAppear {
                if !appSettings.selectedPlaylistId.isEmpty {
                    Task {
                        await musicManager.loadPlaylist(playlistId: appSettings.selectedPlaylistId)
                    }
                }
            }
        }
    }
}

struct ControlButton: View {
    let icon: String
    let size: CGFloat
    let isLandscape: Bool
    let action: () -> Void

    var body: some View {
        let padding = isLandscape ? 25.0 : 40.0

        Button(action: action) {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: size + padding, height: size + padding)
                    .shadow(color: .black.opacity(0.2), radius: 10)

                Image(systemName: icon)
                    .font(.system(size: size))
                    .foregroundColor(.black)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct VolumeButton: View {
    let icon: String
    let isLandscape: Bool
    let action: () -> Void

    var body: some View {
        let buttonSize = isLandscape ? 80.0 : 120.0
        let iconSize = isLandscape ? 35.0 : 50.0
        let cornerRadius = isLandscape ? 20.0 : 25.0

        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.white.opacity(0.8))
                    .frame(width: buttonSize, height: buttonSize)

                Image(systemName: icon)
                    .font(.system(size: iconSize))
                    .foregroundColor(.black)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
