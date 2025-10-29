//
//  AlbumSelectionDialog.swift
//  Luciole
//
//  Dialog for selecting photo albums with search functionality
//

import SwiftUI
import Photos

struct AlbumSelectionDialog: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var photoManager: PhotoManager
    @Binding var selectedAlbumId: String

    @State private var searchText = ""
    @State private var albums: [PHAssetCollection] = []
    @State private var isLoading = false
    @State private var photoCounts: [String: Int] = [:]

    private let maxDisplayedAlbums = 10

    var filteredAlbums: [PHAssetCollection] {
        if searchText.isEmpty {
            return Array(albums.prefix(maxDisplayedAlbums))
        } else {
            return albums.filter { album in
                album.localizedTitle?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .font(.system(size: 18))

                    TextField("Rechercher un album", text: $searchText)
                        .font(.system(size: 18))
                        .textFieldStyle(PlainTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .font(.system(size: 18))
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()

                // Album list
                if isLoading {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.5)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            if filteredAlbums.isEmpty {
                                Text(searchText.isEmpty ? "Aucun album disponible" : "Aucun résultat")
                                    .font(.system(size: 18))
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                ForEach(filteredAlbums, id: \.localIdentifier) { album in
                                    AlbumSelectionRow(
                                        album: album,
                                        photoCount: photoCounts[album.localIdentifier],
                                        isSelected: selectedAlbumId == album.localIdentifier
                                    ) {
                                        selectedAlbumId = album.localIdentifier
                                        dismiss()
                                    }
                                    .onAppear {
                                        loadPhotoCount(for: album)
                                    }

                                    if album != filteredAlbums.last {
                                        Divider()
                                            .padding(.leading)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Sélectionner un album")
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
            loadAlbums()
        }
    }

    private func loadAlbums() {
        isLoading = true
        Task {
            let sortedAlbums = await photoManager.fetchAllAlbumsSorted()
            await MainActor.run {
                albums = sortedAlbums
                isLoading = false
            }
        }
    }

    private func loadPhotoCount(for album: PHAssetCollection) {
        // Don't reload if already cached
        guard photoCounts[album.localIdentifier] == nil else { return }

        let manager = photoManager
        Task.detached(priority: .utility) {
            let count = manager.getPhotoCount(for: album)
            await MainActor.run {
                photoCounts[album.localIdentifier] = count
            }
        }
    }
}

struct AlbumSelectionRow: View {
    let album: PHAssetCollection
    let photoCount: Int?
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(album.localizedTitle ?? "Sans titre")
                        .font(.system(size: 18))
                        .foregroundColor(.primary)

                    if let count = photoCount {
                        Text("\(count) photo\(count > 1 ? "s" : "")")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    } else {
                        // Show loading indicator while counting
                        Text("...")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 22))
                }
            }
            .padding()
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
