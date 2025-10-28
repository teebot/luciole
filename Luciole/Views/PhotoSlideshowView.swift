//
//  PhotoSlideshowView.swift
//  Luciole
//
//  Fullscreen photo slideshow with auto-advance and swipe navigation
//

import SwiftUI
import Photos

struct PhotoSlideshowView: View {
    @Binding var currentScreen: AppScreen
    @EnvironmentObject var appSettings: AppSettings
    @StateObject private var photoManager = PhotoManager()
    @State private var currentIndex = 0
    @State private var timer: Timer?
    @State private var loadedImages: [Int: UIImage] = [:]

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            if photoManager.photos.isEmpty {
                VStack(spacing: 30) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 100))
                        .foregroundColor(.white.opacity(0.5))
                    Text("Aucune photo")
                        .font(.system(size: 48, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                    Text("Configurez un album dans les réglages")
                        .font(.system(size: 32))
                        .foregroundColor(.white.opacity(0.5))
                }
            } else {
                TabView(selection: $currentIndex) {
                    ForEach(Array(photoManager.photos.enumerated()), id: \.offset) { index, asset in
                        PhotoView(
                            asset: asset,
                            loadedImage: loadedImages[index],
                            photoManager: photoManager,
                            onImageLoaded: { image in
                                loadedImages[index] = image
                            }
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .ignoresSafeArea()
            }

            // Back Button
            VStack {
                HStack {
                    Button(action: {
                        stopSlideshow()
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
            photoManager.loadPhotos(albumId: appSettings.selectedPhotoAlbumId)
            startSlideshow()
        }
        .onDisappear {
            stopSlideshow()
        }
        .onChange(of: currentIndex) { _ in
            // Preload next images
            preloadAdjacentImages()
        }
    }

    private func startSlideshow() {
        timer = Timer.scheduledTimer(withTimeInterval: appSettings.slideshowInterval, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % max(photoManager.photos.count, 1)
            }
        }
    }

    private func stopSlideshow() {
        timer?.invalidate()
        timer = nil
    }

    private func preloadAdjacentImages() {
        let screenSize = UIScreen.main.bounds.size
        let targetSize = CGSize(width: screenSize.width * 2, height: screenSize.height * 2)

        // Preload next image
        let nextIndex = (currentIndex + 1) % photoManager.photos.count
        if loadedImages[nextIndex] == nil && nextIndex < photoManager.photos.count {
            let asset = photoManager.photos[nextIndex]
            photoManager.loadImage(for: asset, targetSize: targetSize) { image in
                loadedImages[nextIndex] = image
            }
        }

        // Preload previous image
        let prevIndex = (currentIndex - 1 + photoManager.photos.count) % photoManager.photos.count
        if loadedImages[prevIndex] == nil && prevIndex < photoManager.photos.count {
            let asset = photoManager.photos[prevIndex]
            photoManager.loadImage(for: asset, targetSize: targetSize) { image in
                loadedImages[prevIndex] = image
            }
        }
    }
}

struct PhotoView: View {
    let asset: PHAsset
    let loadedImage: UIImage?
    let photoManager: PhotoManager
    let onImageLoaded: (UIImage) -> Void
    @State private var image: UIImage?

    var body: some View {
        ZStack {
            Color.black

            if let displayImage = image {
                Image(uiImage: displayImage)
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
            } else {
                ProgressView()
                    .scaleEffect(2)
                    .tint(.white)
            }
        }
        .onAppear {
            if let loadedImage = loadedImage {
                image = loadedImage
            } else {
                loadImage()
            }
        }
    }

    private func loadImage() {
        let screenSize = UIScreen.main.bounds.size
        let targetSize = CGSize(width: screenSize.width * 2, height: screenSize.height * 2)

        photoManager.loadImage(for: asset, targetSize: targetSize) { loadedImage in
            if let loadedImage = loadedImage {
                image = loadedImage
                onImageLoaded(loadedImage)
            }
        }
    }
}
