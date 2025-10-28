//
//  SettingsView.swift
//  Luciole
//
//  Settings screen to configure photo albums and music playlists
//

import SwiftUI
import Photos
import MusicKit

struct SettingsView: View {
    @Binding var currentScreen: AppScreen
    @EnvironmentObject var appSettings: AppSettings
    @StateObject private var photoManager = PhotoManager()
    @State private var albums: [PHAssetCollection] = []
    @State private var userPlaylists: [Playlist] = []
    @State private var showingMusicSearch = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        Text("Réglages")
                            .font(.system(size: 48, weight: .bold))
                            .padding(.top, 40)

                        // Photo Album Section
                        VStack(alignment: .leading, spacing: 20) {
                            Label {
                                Text("Album Photo")
                                    .font(.system(size: 28, weight: .semibold))
                            } icon: {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.system(size: 28))
                                    .foregroundColor(.blue)
                            }

                            if photoManager.authorizationStatus == .authorized {
                                if albums.isEmpty {
                                    Text("Aucun album disponible")
                                        .font(.system(size: 20))
                                        .foregroundColor(.gray)
                                        .padding()
                                } else {
                                    ForEach(albums, id: \.localIdentifier) { album in
                                        AlbumRow(
                                            album: album,
                                            isSelected: appSettings.selectedPhotoAlbumId == album.localIdentifier
                                        ) {
                                            appSettings.selectedPhotoAlbumId = album.localIdentifier
                                        }
                                    }
                                }
                            } else {
                                Button(action: {
                                    photoManager.checkAuthorization()
                                }) {
                                    Text("Autoriser l'accès aux photos")
                                        .font(.system(size: 24, weight: .medium))
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue)
                                        .cornerRadius(15)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)

                        // Slideshow Interval
                        VStack(alignment: .leading, spacing: 20) {
                            Label {
                                Text("Durée par photo")
                                    .font(.system(size: 28, weight: .semibold))
                            } icon: {
                                Image(systemName: "timer")
                                    .font(.system(size: 28))
                                    .foregroundColor(.blue)
                            }

                            HStack {
                                Text("\(Int(appSettings.slideshowInterval)) secondes")
                                    .font(.system(size: 24))
                                    .foregroundColor(.gray)

                                Spacer()

                                Stepper("", value: $appSettings.slideshowInterval, in: 2...30, step: 1)
                                    .labelsHidden()
                                    .scaleEffect(1.5)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)

                        // Music Playlist Section
                        VStack(alignment: .leading, spacing: 20) {
                            Label {
                                Text("Playlist Apple Music")
                                    .font(.system(size: 28, weight: .semibold))
                            } icon: {
                                Image(systemName: "music.note.list")
                                    .font(.system(size: 28))
                                    .foregroundColor(.pink)
                            }

                            Button(action: {
                                showingMusicSearch = true
                            }) {
                                Text("Chercher une playlist")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.pink)
                                    .cornerRadius(15)
                            }

                            if !appSettings.selectedPlaylistId.isEmpty {
                                Text("✓ Playlist configurée")
                                    .font(.system(size: 20))
                                    .foregroundColor(.green)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)

                        // Kiosk Mode Instructions
                        VStack(alignment: .leading, spacing: 15) {
                            Label {
                                Text("Mode Kiosque")
                                    .font(.system(size: 28, weight: .semibold))
                            } icon: {
                                Image(systemName: "lock.shield")
                                    .font(.system(size: 28))
                                    .foregroundColor(.orange)
                            }

                            Text("Pour activer le mode kiosque sur iPad:")
                                .font(.system(size: 20, weight: .medium))

                            VStack(alignment: .leading, spacing: 10) {
                                InstructionRow(number: "1", text: "Ouvrez Réglages > Accessibilité")
                                InstructionRow(number: "2", text: "Activez 'Accès guidé'")
                                InstructionRow(number: "3", text: "Dans Luciole, triple-cliquez le bouton latéral")
                                InstructionRow(number: "4", text: "L'application restera verrouillée")
                            }
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)

                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 40)
                }

                // Back Button
                VStack {
                    HStack {
                        Button(action: {
                            currentScreen = .home
                        }) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.system(size: 70))
                                .foregroundColor(.blue)
                        }
                        .padding(30)
                        Spacer()
                    }
                    Spacer()
                }
            }
            .sheet(isPresented: $showingMusicSearch) {
                MusicSearchView(selectedPlaylistId: $appSettings.selectedPlaylistId)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            albums = photoManager.fetchAllAlbums()
        }
    }
}

struct AlbumRow: View {
    let album: PHAssetCollection
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(album.localizedTitle ?? "Album sans nom")
                    .font(.system(size: 22))
                    .foregroundColor(.black)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
            .cornerRadius(15)
        }
    }
}

struct InstructionRow: View {
    let number: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Text(number)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
                .background(Color.orange)
                .clipShape(Circle())

            Text(text)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct MusicSearchView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedPlaylistId: String
    @State private var searchText = ""
    @State private var searchResults: [Playlist] = []
    @State private var isSearching = false

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .font(.system(size: 24))

                    TextField("Chercher une playlist", text: $searchText)
                        .font(.system(size: 24))
                        .textFieldStyle(PlainTextFieldStyle())
                        .onSubmit {
                            searchPlaylists()
                        }

                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            searchResults = []
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .font(.system(size: 24))
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding()

                // Results
                if isSearching {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                } else if searchResults.isEmpty && !searchText.isEmpty {
                    Text("Aucune playlist trouvée")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(searchResults, id: \.id) { playlist in
                        Button(action: {
                            selectedPlaylistId = playlist.id.rawValue
                            dismiss()
                        }) {
                            HStack {
                                if let artwork = playlist.artwork {
                                    ArtworkImage(artwork, width: 60, height: 60)
                                        .cornerRadius(10)
                                }

                                VStack(alignment: .leading) {
                                    Text(playlist.name)
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.black)

                                    if let curatorName = playlist.curatorName {
                                        Text(curatorName)
                                            .font(.system(size: 16))
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .listStyle(PlainListStyle())
                }

                Spacer()
            }
            .navigationTitle("Playlists")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .font(.system(size: 20))
                }
            }
        }
    }

    private func searchPlaylists() {
        guard !searchText.isEmpty else { return }

        isSearching = true

        Task {
            do {
                var request = MusicCatalogSearchRequest(term: searchText, types: [Playlist.self])
                request.limit = 25

                let response = try await request.response()

                await MainActor.run {
                    searchResults = response.playlists.map { $0 }
                    isSearching = false
                }
            } catch {
                print("Search error: \(error)")
                await MainActor.run {
                    isSearching = false
                }
            }
        }
    }
}
