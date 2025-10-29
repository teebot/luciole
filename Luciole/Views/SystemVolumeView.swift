//
//  SystemVolumeView.swift
//  Luciole
//
//  UIKit wrapper for MPVolumeView to control system volume
//

import SwiftUI
import MediaPlayer

struct SystemVolumeView: UIViewRepresentable {
    func makeUIView(context: Context) -> MPVolumeView {
        let volumeView = MPVolumeView(frame: .zero)
        volumeView.showsRouteButton = false
        volumeView.setVolumeThumbImage(UIImage(), for: .normal)
        volumeView.isUserInteractionEnabled = false
        return volumeView
    }

    func updateUIView(_ uiView: MPVolumeView, context: Context) {
        // No updates needed
    }
}

class VolumeController: ObservableObject {
    private var volumeView: MPVolumeView?
    @Published var currentVolume: Float = 0.5

    init() {
        setupVolumeView()
        currentVolume = AVAudioSession.sharedInstance().outputVolume
    }

    private func setupVolumeView() {
        volumeView = MPVolumeView(frame: .zero)
        volumeView?.showsRouteButton = false
        // Keep reference but don't need to display it
    }

    func increaseVolume() {
        guard let volumeView = volumeView,
              let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider else {
            print("⚠️ Volume slider not found")
            return
        }

        let newValue = min(slider.value + 0.1, 1.0)
        slider.value = newValue
        currentVolume = newValue
        print("🔊 Volume increased to: \(newValue)")
    }

    func decreaseVolume() {
        guard let volumeView = volumeView,
              let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider else {
            print("⚠️ Volume slider not found")
            return
        }

        let newValue = max(slider.value - 0.1, 0.0)
        slider.value = newValue
        currentVolume = newValue
        print("🔉 Volume decreased to: \(newValue)")
    }
}
