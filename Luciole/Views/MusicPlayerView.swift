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
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [.pink.opacity(0.3), .purple.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 50) {
                Spacer()

                // Album Art or Music Icon
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.2))
                        .frame(width: 400, height: 400)

                    if let artwork = musicManager.currentSong?.artwork {
                        ArtworkImage(artwork, width: 350, height: 350)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "music.note")
                            .font(.system(size: 150))
                            .foregroundColor(.white)
                    }
                }

                // Song Information
                VStack(spacing: 10) {
                    Text(musicManager.currentSong?.title ?? "Aucune musique")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.black)
                        .lineLimit(1)

                    Text(musicManager.currentSong?.artistName ?? "")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(.black.opacity(0.7))
                        .lineLimit(1)
                }
                .frame(maxWidth: 800)

                Spacer()

                // Playback Controls
                HStack(spacing: 60) {
                    // Previous Button
                    ControlButton(icon: "backward.fill", size: 70) {
                        musicManager.skipToPrevious()
                    }

                    // Play/Pause Button
                    ControlButton(
                        icon: musicManager.isPlaying ? "pause.fill" : "play.fill",
                        size: 100
                    ) {
                        if musicManager.isPlaying {
                            musicManager.pause()
                        } else {
                            musicManager.play()
                        }
                    }

                    // Next Button
                    ControlButton(icon: "forward.fill", size: 70) {
                        musicManager.skipToNext()
                    }
                }

                // Volume Controls
                HStack(spacing: 100) {
                    VolumeButton(icon: "speaker.minus.fill") {
                        musicManager.decreaseVolume()
                    }

                    VolumeButton(icon: "speaker.plus.fill") {
                        musicManager.increaseVolume()
                    }
                }
                .padding(.bottom, 40)

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
                            .font(.system(size: 80))
                            .foregroundColor(.white.opacity(0.8))
                            .shadow(color: .black.opacity(0.3), radius: 10)
                    }
                    .padding(40)
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

struct ControlButton: View {
    let icon: String
    let size: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: size + 40, height: size + 40)
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
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.white.opacity(0.8))
                    .frame(width: 120, height: 120)

                Image(systemName: icon)
                    .font(.system(size: 50))
                    .foregroundColor(.black)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
