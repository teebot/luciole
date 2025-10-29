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
                                    photoCount: photoManager.getPhotoCount(for: album),
                                    isSelected: selectedAlbumId == album.localIdentifier
                                ) {
                                    selectedAlbumId = album.localIdentifier
                                    dismiss()
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
            albums = photoManager.fetchAllAlbums()
        }
    }
}

struct AlbumSelectionRow: View {
    let album: PHAssetCollection
    let photoCount: Int
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(album.localizedTitle ?? "Sans titre")
                        .font(.system(size: 18))
                        .foregroundColor(.primary)

                    Text("\(photoCount) photo\(photoCount > 1 ? "s" : "")")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
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
