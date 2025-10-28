//
//  PhotoManager.swift
//  Luciole
//
//  Manages photo album access and loading
//

import Foundation
import Photos
import SwiftUI

class PhotoManager: ObservableObject {
    @Published var photos: [PHAsset] = []
    @Published var authorizationStatus: PHAuthorizationStatus = .notDetermined

    init() {
        checkAuthorization()
    }

    func checkAuthorization() {
        authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if authorizationStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                DispatchQueue.main.async {
                    self?.authorizationStatus = status
                }
            }
        }
    }

    func loadPhotos(albumId: String) {
        guard !albumId.isEmpty else { return }

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        if let album = PHAssetCollection.fetchAssetCollections(
            withLocalIdentifiers: [albumId],
            options: nil
        ).firstObject {
            let assets = PHAsset.fetchAssets(in: album, options: fetchOptions)
            var loadedPhotos: [PHAsset] = []
            assets.enumerateObjects { asset, _, _ in
                if asset.mediaType == .image {
                    loadedPhotos.append(asset)
                }
            }
            self.photos = loadedPhotos
        }
    }

    func loadImage(for asset: PHAsset, targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true

        imageManager.requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFill,
            options: options
        ) { image, _ in
            completion(image)
        }
    }

    func fetchAllAlbums() -> [PHAssetCollection] {
        var albums: [PHAssetCollection] = []

        // User albums
        let userAlbums = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .any,
            options: nil
        )
        userAlbums.enumerateObjects { collection, _, _ in
            albums.append(collection)
        }

        // Smart albums (like Favorites, Recents, etc.)
        let smartAlbums = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .any,
            options: nil
        )
        smartAlbums.enumerateObjects { collection, _, _ in
            albums.append(collection)
        }

        return albums
    }
}
