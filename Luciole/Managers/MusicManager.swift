//
//  MusicManager.swift
//  Luciole
//
//  Manages Apple Music playback using MusicKit
//

import Foundation
import MusicKit
import MediaPlayer

class MusicManager: ObservableObject {
    static let shared = MusicManager()

    @Published var authorizationStatus: MusicAuthorization.Status = .notDetermined
    @Published var isPlaying = false
    @Published var currentSong: Song?
    @Published var playbackTime: TimeInterval = 0
    @Published var volume: Float = 0.5

    private let player = ApplicationMusicPlayer.shared
    private var timer: Timer?

    init() {
        checkAuthorization()
        setupNotifications()
        setupVolumeControl()
    }

    func checkAuthorization() {
        Task {
            let status = await MusicAuthorization.request()
            await MainActor.run {
                self.authorizationStatus = status
            }
        }
    }

    func loadPlaylist(playlistId: String) async {
        guard !playlistId.isEmpty else { return }

        do {
            // Fetch playlist by ID
            var request = MusicCatalogResourceRequest<Playlist>(matching: \.id, equalTo: MusicItemID(playlistId))
            request.properties = [.tracks]

            let response = try await request.response()

            if let playlist = response.items.first {
                // Get tracks from playlist
                if let tracks = playlist.tracks {
                    // Shuffle the tracks
                    var shuffledTracks = Array(tracks)
                    shuffledTracks.shuffle()

                    // Set the queue with shuffled tracks
                    player.queue = ApplicationMusicPlayer.Queue(for: shuffledTracks)

                    // Start playing
                    try await player.play()

                    await MainActor.run {
                        self.isPlaying = true
                        startTimer()
                    }
                }
            }
        } catch {
            print("Error loading playlist: \(error)")
        }
    }

    func play() {
        Task {
            do {
                try await player.play()
                await MainActor.run {
                    self.isPlaying = true
                    startTimer()
                }
            } catch {
                print("Error playing: \(error)")
            }
        }
    }

    func pause() {
        Task {
            player.pause()
            await MainActor.run {
                self.isPlaying = false
                stopTimer()
            }
        }
    }

    func skipToNext() {
        Task {
            do {
                try await player.skipToNextEntry()
            } catch {
                print("Error skipping to next: \(error)")
            }
        }
    }

    func skipToPrevious() {
        Task {
            do {
                try await player.skipToPreviousEntry()
            } catch {
                print("Error skipping to previous: \(error)")
            }
        }
    }

    func stop() {
        Task {
            player.stop()
            await MainActor.run {
                self.isPlaying = false
                self.currentSong = nil
                stopTimer()
            }
        }
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateNowPlayingInfo),
            name: .MPMusicPlayerControllerNowPlayingItemDidChange,
            object: nil
        )
    }

    @objc private func updateNowPlayingInfo() {
        Task {
            if let currentEntry = player.queue.currentEntry {
                if case .song(let song) = currentEntry.item {
                    await MainActor.run {
                        self.currentSong = song
                    }
                }
            }
        }
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.playbackTime = self?.player.playbackTime ?? 0

                // Update current song
                if let currentEntry = self?.player.queue.currentEntry {
                    if case .song(let song) = currentEntry.item {
                        self?.currentSong = song
                    }
                }
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func setupVolumeControl() {
        // Get initial volume
        volume = AVAudioSession.sharedInstance().outputVolume
    }

    func increaseVolume() {
        let volumeView = MPVolumeView()
        if let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider {
            slider.value = min(slider.value + 0.1, 1.0)
        }
    }

    func decreaseVolume() {
        let volumeView = MPVolumeView()
        if let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider {
            slider.value = max(slider.value - 0.1, 0.0)
        }
    }
}
