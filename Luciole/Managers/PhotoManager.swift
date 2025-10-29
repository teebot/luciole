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

        // Built-in smart album subtypes to exclude
        let excludedSmartAlbumSubtypes: [PHAssetCollectionSubtype] = [
            .smartAlbumFavorites,
            .smartAlbumRecentlyAdded,
            .smartAlbumScreenshots,
            .smartAlbumSelfPortraits,
            .smartAlbumPanoramas,
            .smartAlbumVideos,
            .smartAlbumSlomoVideos,
            .smartAlbumTimelapses,
            .smartAlbumBursts,
            .smartAlbumAllHidden,
            .smartAlbumLivePhotos,
            .smartAlbumDepthEffect,
            .smartAlbumLongExposures,
            .smartAlbumAnimated,
            .smartAlbumUnableToUpload
        ]

        // User albums
        let userAlbums = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .any,
            options: nil
        )
        userAlbums.enumerateObjects { collection, _, _ in
            albums.append(collection)
        }

        // Smart albums - only include user-created or non-standard ones
        let smartAlbums = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .any,
            options: nil
        )
        smartAlbums.enumerateObjects { collection, _, _ in
            // Filter out built-in smart albums
            if !excludedSmartAlbumSubtypes.contains(collection.assetCollectionSubtype) {
                albums.append(collection)
            }
        }

        // Return albums without sorting - sorting happens asynchronously in the view
        return albums
    }

    func fetchAllAlbumsSorted() async -> [PHAssetCollection] {
        // Fetch albums on background thread
        return await Task.detached(priority: .userInitiated) {
            let albums = self.fetchAllAlbums()

            // Sort by most recent photo date (descending)
            return albums.sorted { album1, album2 in
                let date1 = self.getLatestPhotoDate(for: album1)
                let date2 = self.getLatestPhotoDate(for: album2)
                return date1 > date2
            }
        }.value
    }

    func getLatestPhotoDate(for album: PHAssetCollection) -> Date {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1

        let assets = PHAsset.fetchAssets(in: album, options: fetchOptions)
        if let latestAsset = assets.firstObject {
            return latestAsset.creationDate ?? Date.distantPast
        }
        return Date.distantPast
    }

    func getPhotoCount(for album: PHAssetCollection) -> Int {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        let assets = PHAsset.fetchAssets(in: album, options: fetchOptions)
        return assets.count
    }
}
