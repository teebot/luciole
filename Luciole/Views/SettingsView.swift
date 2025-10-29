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
    @State private var selectedPlaylist: Playlist?
    @State private var selectedAlbumPhotoCount: Int?

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
                                Text("Message d'accueil")
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

                                            if let count = selectedAlbumPhotoCount {
                                                Text("\(count) photo\(count > 1 ? "s" : "")")
                                                    .font(.system(size: 16))
                                                    .foregroundColor(.gray)
                                            } else {
                                                Text("...")
                                                    .font(.system(size: 16))
                                                    .foregroundColor(.gray)
                                            }
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
                                Text("Sélectionner une playlist")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.pink)
                                    .cornerRadius(15)
                            }

                            if let playlist = selectedPlaylist {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("✓ \(playlist.name)")
                                            .font(.system(size: 20, weight: .medium))
                                            .foregroundColor(.green)

                                        if let curatorName = playlist.curatorName {
                                            Text(curatorName)
                                                .font(.system(size: 16))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal)
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
            loadSelectedAlbum()
            loadSelectedPlaylist()
        }
        .onChange(of: appSettings.selectedPlaylistId) { _ in
            loadSelectedPlaylist()
        }
        .onChange(of: appSettings.selectedPhotoAlbumId) { _ in
            loadSelectedAlbum()
        }
    }

    private func loadSelectedAlbum() {
        guard !appSettings.selectedPhotoAlbumId.isEmpty else {
            albums = []
            selectedAlbumPhotoCount = nil
            return
        }

        // Reset photo count while loading
        selectedAlbumPhotoCount = nil

        // Fetch only the selected album, not all albums
        Task {
            await MainActor.run {
                if let album = PHAssetCollection.fetchAssetCollections(
                    withLocalIdentifiers: [appSettings.selectedPhotoAlbumId],
                    options: nil
                ).firstObject {
                    albums = [album]

                    // Load photo count asynchronously
                    let manager = photoManager
                    Task.detached(priority: .utility) {
                        let count = manager.getPhotoCount(for: album)
                        await MainActor.run {
                            selectedAlbumPhotoCount = count
                        }
                    }
                } else {
                    albums = []
                }
            }
        }
    }

    private func loadSelectedPlaylist() {
        guard !appSettings.selectedPlaylistId.isEmpty else {
            selectedPlaylist = nil
            return
        }

        Task {
            do {
                let status = MusicAuthorization.currentStatus
                guard status == .authorized else { return }

                // Fetch playlist by ID
                let request = MusicLibraryRequest<Playlist>()
                let response = try await request.response()

                await MainActor.run {
                    selectedPlaylist = response.items.first { playlist in
                        playlist.id.rawValue == appSettings.selectedPlaylistId
                    }
                }
            } catch {
                print("Error loading selected playlist: \(error)")
            }
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
    @State private var allPlaylists: [Playlist] = []
    @State private var isLoading = false
    @State private var authorizationStatus: MusicAuthorization.Status = .notDetermined
    @State private var errorMessage: String?

    var displayedPlaylists: [Playlist] {
        // Sort by last modified date (most recent first)
        let sortedPlaylists = allPlaylists.sorted { playlist1, playlist2 in
            let date1 = playlist1.lastModifiedDate ?? Date.distantPast
            let date2 = playlist2.lastModifiedDate ?? Date.distantPast
            return date1 > date2
        }

        if searchText.isEmpty {
            // Show only 10 most recent when not searching
            return Array(sortedPlaylists.prefix(10))
        } else {
            // Show all matching playlists when searching (autocomplete)
            return sortedPlaylists.filter { playlist in
                playlist.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

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

                        Text("Autorisez l'accès à Apple Music pour accéder à vos playlists")
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

                        TextField("Rechercher une playlist", text: $searchText)
                            .font(.system(size: 24))
                            .textFieldStyle(PlainTextFieldStyle())
                            .autocapitalization(.none)
                            .disableAutocorrection(true)

                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
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
                    if isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding()
                    } else if allPlaylists.isEmpty && errorMessage == nil {
                        Text("Aucune playlist dans votre bibliothèque")
                            .font(.system(size: 22))
                            .foregroundColor(.gray)
                            .padding()
                    } else if displayedPlaylists.isEmpty && !searchText.isEmpty {
                        Text("Aucune playlist trouvée")
                            .font(.system(size: 22))
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        List(displayedPlaylists, id: \.id) { playlist in
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
            .navigationTitle("Sélectionner une playlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Annuler") {
                        dismiss()
                    }
                    .font(.system(size: 18))
                }
            }
        }
        .onAppear {
            checkAuthorization()
            if authorizationStatus == .authorized {
                loadUserPlaylists()
            }
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
                if status == .authorized {
                    loadUserPlaylists()
                }
            }
        }
    }

    private func loadUserPlaylists() {
        print("🔍 Loading user's library playlists")
        isLoading = true
        errorMessage = nil

        Task {
            do {
                // Check authorization before fetching
                let status = MusicAuthorization.currentStatus
                print("🔍 Authorization status: \(status)")

                guard status == .authorized else {
                    print("❌ Not authorized to access library: \(status)")
                    await MainActor.run {
                        errorMessage = "Accès Apple Music non autorisé"
                        isLoading = false
                    }
                    return
                }

                // Fetch user's library playlists
                let request = MusicLibraryRequest<Playlist>()
                let response = try await request.response()

                print("✅ Loaded \(response.items.count) playlists from library")

                await MainActor.run {
                    allPlaylists = Array(response.items)
                    isLoading = false

                    if allPlaylists.isEmpty {
                        print("⚠️ No playlists in user's library")
                    }
                }
            } catch let error as NSError {
                print("❌ Error loading playlists: \(error)")
                print("❌ Error domain: \(error.domain)")
                print("❌ Error code: \(error.code)")
                print("❌ Error userInfo: \(error.userInfo)")
                print("❌ Error description: \(error.localizedDescription)")

                var friendlyMessage = "Erreur de chargement"

                // Provide more specific error messages
                if error.domain == "SKErrorDomain" {
                    switch error.code {
                    case 3: // Network unavailable
                        friendlyMessage = "Pas de connexion internet"
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
                    isLoading = false
                }
            } catch {
                print("❌ Unknown error loading playlists: \(error)")
                print("❌ Error type: \(type(of: error))")
                await MainActor.run {
                    errorMessage = "Erreur inconnue: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }
}
