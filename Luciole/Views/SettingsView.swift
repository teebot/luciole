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
    @State private var showingAlbumSelection = false

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

                        // App Title Section
                        VStack(alignment: .leading, spacing: 20) {
                            Label {
                                Text("Titre de l'application")
                                    .font(.system(size: 28, weight: .semibold))
                            } icon: {
                                Image(systemName: "textformat")
                                    .font(.system(size: 28))
                                    .foregroundColor(.purple)
                            }

                            TextField("Nom de l'application", text: $appSettings.appTitle)
                                .font(.system(size: 24))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                                .onChange(of: appSettings.appTitle) { newValue in
                                    // Limit to 16 characters
                                    if newValue.count > 16 {
                                        appSettings.appTitle = String(newValue.prefix(16))
                                    }
                                }

                            Text("\(appSettings.appTitle.count)/16 caractères")
                                .font(.system(size: 18))
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)

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
                                Button(action: {
                                    showingAlbumSelection = true
                                }) {
                                    Text("Sélectionner un album")
                                        .font(.system(size: 24, weight: .medium))
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue)
                                        .cornerRadius(15)
                                }

                                if !appSettings.selectedPhotoAlbumId.isEmpty,
                                   let selectedAlbum = albums.first(where: { $0.localIdentifier == appSettings.selectedPhotoAlbumId }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("✓ \(selectedAlbum.localizedTitle ?? "Album")")
                                                .font(.system(size: 20, weight: .medium))
                                                .foregroundColor(.green)

                                            Text("\(photoManager.getPhotoCount(for: selectedAlbum)) photo(s)")
                                                .font(.system(size: 16))
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal)
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
            .sheet(isPresented: $showingAlbumSelection) {
                AlbumSelectionDialog(
                    photoManager: photoManager,
                    selectedAlbumId: $appSettings.selectedPhotoAlbumId
                )
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
    @State private var authorizationStatus: MusicAuthorization.Status = .notDetermined
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                // Authorization check
                if authorizationStatus != .authorized {
                    VStack(spacing: 20) {
                        Image(systemName: "music.note.list")
                            .font(.system(size: 60))
                            .foregroundColor(.pink)

                        Text("Accès Apple Music requis")
                            .font(.system(size: 24, weight: .semibold))

                        Text("Autorisez l'accès à Apple Music pour rechercher des playlists")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Button(action: {
                            requestAuthorization()
                        }) {
                            Text("Autoriser")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: 300)
                                .background(Color.pink)
                                .cornerRadius(15)
                        }
                    }
                    .padding()
                } else {
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
                                errorMessage = nil
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

                    // Error message
                    if let error = errorMessage {
                        Text(error)
                            .font(.system(size: 18))
                            .foregroundColor(.red)
                            .padding()
                    }

                    // Results
                    if isSearching {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding()
                    } else if searchResults.isEmpty && !searchText.isEmpty && errorMessage == nil {
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
        .onAppear {
            checkAuthorization()
        }
    }

    private func checkAuthorization() {
        authorizationStatus = MusicAuthorization.currentStatus
        print("🎵 MusicKit authorization status: \(authorizationStatus)")
    }

    private func requestAuthorization() {
        Task {
            let status = await MusicAuthorization.request()
            await MainActor.run {
                authorizationStatus = status
                print("🎵 MusicKit authorization updated: \(status)")
            }
        }
    }

    private func searchPlaylists() {
        guard !searchText.isEmpty else { return }

        print("🔍 Searching for playlists: \(searchText)")
        isSearching = true
        errorMessage = nil

        Task {
            do {
                // Check authorization before searching
                let status = MusicAuthorization.currentStatus
                print("🔍 Authorization status: \(status)")

                guard status == .authorized else {
                    print("❌ Not authorized to search: \(status)")
                    await MainActor.run {
                        errorMessage = "Accès Apple Music non autorisé"
                        isSearching = false
                    }
                    return
                }

                // Check for Apple Music subscription
                let subscriptionStatus = MusicSubscription.current
                print("🔍 Subscription status: \(subscriptionStatus)")

                var request = MusicCatalogSearchRequest(term: searchText, types: [Playlist.self])
                request.limit = 25

                print("🔍 Making search request for term: '\(searchText)'")
                let response = try await request.response()

                print("✅ Search complete: \(response.playlists.count) playlists found")

                await MainActor.run {
                    searchResults = response.playlists.map { $0 }
                    isSearching = false

                    if searchResults.isEmpty {
                        print("⚠️ No results for: \(searchText)")
                    }
                }
            } catch let error as NSError {
                print("❌ Search error: \(error)")
                print("❌ Error domain: \(error.domain)")
                print("❌ Error code: \(error.code)")
                print("❌ Error userInfo: \(error.userInfo)")
                print("❌ Error description: \(error.localizedDescription)")

                var friendlyMessage = "Erreur de recherche"

                // Provide more specific error messages
                if error.domain == "SKErrorDomain" {
                    switch error.code {
                    case 3: // Network unavailable
                        friendlyMessage = "Pas de connexion internet"
                    case 5: // Not entitled (no subscription)
                        friendlyMessage = "Abonnement Apple Music requis"
                    default:
                        friendlyMessage = "Erreur Apple Music (code \(error.code))"
                    }
                } else if error.domain == NSURLErrorDomain {
                    friendlyMessage = "Erreur réseau"
                } else {
                    friendlyMessage = "Erreur: \(error.localizedDescription)"
                }

                await MainActor.run {
                    errorMessage = friendlyMessage
                    isSearching = false
                }
            } catch {
                print("❌ Unknown search error: \(error)")
                print("❌ Error type: \(type(of: error))")
                await MainActor.run {
                    errorMessage = "Erreur inconnue: \(error.localizedDescription)"
                    isSearching = false
                }
            }
        }
    }
}
