//
//  AppSettings.swift
//  Luciole
//
//  Stores user preferences for photo albums and music playlists
//

import Foundation
import SwiftUI

class AppSettings: ObservableObject {
    @AppStorage("selectedPhotoAlbumId") var selectedPhotoAlbumId: String = ""
    @AppStorage("selectedPlaylistId") var selectedPlaylistId: String = ""
    @AppStorage("slideshowInterval") var slideshowInterval: Double = 5.0 // seconds
    @AppStorage("appTitle") var appTitle: String = "Hello :)"
}
