# Luciole - Application Flow

## Screen Navigation

```
                    ┌─────────────────────┐
                    │    LucioleApp       │
                    │   (Entry Point)     │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │   ContentView       │
                    │ (Main Coordinator)  │
                    └──────────┬──────────┘
                               │
                               ▼
        ┌──────────────────────┴──────────────────────┐
        │                                              │
        ▼                                              ▼
┌──────────────┐                              ┌──────────────┐
│   HomeView   │                              │ SettingsView │
│              │◄─────────────────────────────│              │
│  ┌────────┐  │                              │ • Albums     │
│  │ Photos │  │                              │ • Playlists  │
│  └────────┘  │                              │ • Timing     │
│              │                              │ • Kiosk Info │
│  ┌────────┐  │                              └──────────────┘
│  │ Music  │  │
│  └────────┘  │
│              │
│   [⚙ Settings]│
└───┬──────┬────┘
    │      │
    │      └────────────────┐
    │                       │
    ▼                       ▼
┌──────────────────┐  ┌──────────────────┐
│PhotoSlideshowView│  │ MusicPlayerView  │
│                  │  │                  │
│ ┌──────────────┐ │  │  ┌──────────┐   │
│ │ [← Back]     │ │  │  │ [← Back] │   │
│ └──────────────┘ │  │  └──────────┘   │
│                  │  │                  │
│  ┌────────────┐  │  │  ┌────────────┐ │
│  │            │  │  │  │  Artwork   │ │
│  │   Photo    │  │  │  │            │ │
│  │            │  │  │  └────────────┘ │
│  └────────────┘  │  │                  │
│                  │  │    Song Title    │
│  ◄ Swipe ►       │  │    Artist        │
│  Auto-advance    │  │                  │
│                  │  │  ◄  ▶/⏸  ►       │
│                  │  │                  │
│                  │  │  Vol-    Vol+    │
└──────────────────┘  └──────────────────┘
```

## User Journey

### First Time Setup

```
1. Launch App
   │
   ├─► Request Photo Permission
   │   └─► User Grants Permission
   │
   ├─► Request Music Permission
   │   └─► User Grants Permission
   │
   └─► Land on HomeView

2. Open Settings (⚙)
   │
   ├─► Select Photo Album
   │   └─► Choose from list of albums
   │
   ├─► Search Music Playlist
   │   ├─► Enter search term
   │   ├─► Browse results
   │   └─► Select playlist
   │
   └─► Return to Home

3. Enable Kiosk Mode (Optional)
   │
   ├─► iPad Settings → Accessibility
   ├─► Enable Guided Access
   ├─► Set Passcode
   └─► In app: Triple-click side button
```

### Daily Use (Person with Dementia)

```
                 ┌─────────────┐
                 │  HomeView   │
                 └──────┬──────┘
                        │
        ┌───────────────┴───────────────┐
        │                               │
   Tap "Photos"                    Tap "Music"
        │                               │
        ▼                               ▼
┌───────────────┐             ┌─────────────────┐
│  Slideshow    │             │  Music Player   │
│               │             │                 │
│  Photo 1      │             │  ♫ Playing...   │
│    ↓ 5s       │             │                 │
│  Photo 2      │             │  [Pause] [Next] │
│    ↓ 5s       │             │                 │
│  Photo 3      │             │  [Vol-] [Vol+]  │
│    ...        │             │                 │
│               │             │                 │
│  [Swipe OK]   │             │  [Controls]     │
│               │             │                 │
└───────┬───────┘             └────────┬────────┘
        │                              │
   Tap [←Back]                    Tap [←Back]
        │                              │
        └──────────────┬───────────────┘
                       │
                       ▼
                 ┌──────────┐
                 │   Home   │
                 └──────────┘
```

## State Management Flow

### AppSettings (Global State)

```
┌─────────────────────────────────────────┐
│           AppSettings                    │
│       (@EnvironmentObject)               │
├─────────────────────────────────────────┤
│                                          │
│  @AppStorage Properties:                 │
│  • selectedPhotoAlbumId: String          │
│  • selectedPlaylistId: String            │
│  • slideshowInterval: Double             │
│                                          │
└───────────┬─────────────────────────────┘
            │
            │ Injected into all views
            │
    ┌───────┴────────┬─────────┬──────────┐
    │                │         │          │
    ▼                ▼         ▼          ▼
 HomeView    PhotoView   MusicView  SettingsView
    │                │         │          │
    │                │         │          │
    └────────────────┴─────────┴──────────┘
           All can read/write settings
```

### Photo Manager Flow

```
┌─────────────────────────────────────────┐
│         PhotoManager                     │
│       (@StateObject)                     │
├─────────────────────────────────────────┤
│                                          │
│  @Published Properties:                  │
│  • photos: [PHAsset]                     │
│  • authorizationStatus                   │
│                                          │
│  Methods:                                │
│  • checkAuthorization()                  │
│  • loadPhotos(albumId:)                  │
│  • loadImage(for:targetSize:)            │
│  • fetchAllAlbums()                      │
│                                          │
└───────────┬─────────────────────────────┘
            │
    ┌───────┴──────────┐
    │                  │
    ▼                  ▼
PhotoSlideshowView  SettingsView
    │                  │
    │ Displays         │ Configures
    │ Photos           │ Album
    │                  │
```

### Music Manager Flow

```
┌─────────────────────────────────────────┐
│       MusicManager (Singleton)           │
│         MusicManager.shared              │
├─────────────────────────────────────────┤
│                                          │
│  @Published Properties:                  │
│  • isPlaying: Bool                       │
│  • currentSong: Song?                    │
│  • playbackTime: TimeInterval            │
│  • volume: Float                         │
│                                          │
│  Methods:                                │
│  • loadPlaylist(playlistId:)             │
│  • play() / pause() / stop()             │
│  • skipToNext() / skipToPrevious()       │
│  • increaseVolume() / decreaseVolume()   │
│                                          │
└───────────┬─────────────────────────────┘
            │
    ┌───────┴──────────┐
    │                  │
    ▼                  ▼
MusicPlayerView    HomeView
    │                  │
    │ Controls         │ Displays
    │ Playback         │ Status
    │                  │
```

## Data Flow Diagrams

### Photo Slideshow Flow

```
User taps "Photos"
        │
        ▼
PhotoSlideshowView.onAppear()
        │
        ├─► photoManager.loadPhotos(albumId)
        │   └─► Fetch PHAssets from album
        │       └─► Update @Published photos array
        │
        ├─► startSlideshow()
        │   └─► Create Timer (interval: slideshowInterval)
        │       └─► Every N seconds: currentIndex++
        │
        └─► preloadAdjacentImages()
            └─► Load next & previous images
                └─► Cache in loadedImages dict
```

### Music Playback Flow

```
User taps "Music"
        │
        ▼
MusicPlayerView.onAppear()
        │
        └─► Task { await musicManager.loadPlaylist(playlistId) }
                │
                ├─► MusicCatalogResourceRequest(matching: \.id)
                │   └─► Fetch playlist from Apple Music
                │
                ├─► playlist.tracks.shuffled()
                │   └─► Randomize track order
                │
                ├─► player.queue = Queue(shuffledTracks)
                │   └─► Set playback queue
                │
                └─► player.play()
                    └─► Update isPlaying = true
                        └─► Start playback timer
                            └─► Update current song info
```

### Settings Configuration Flow

```
User opens Settings
        │
        ▼
SettingsView.onAppear()
        │
        └─► albums = photoManager.fetchAllAlbums()
                │
                └─► Display album list

User selects album
        │
        └─► appSettings.selectedPhotoAlbumId = album.id
                │
                └─► Persisted to @AppStorage
                    └─► Available globally

User searches playlist
        │
        ├─► Present MusicSearchView sheet
        │       │
        │       └─► MusicCatalogSearchRequest(term:)
        │           └─► Display results
        │
        └─► User selects playlist
                │
                └─► appSettings.selectedPlaylistId = playlist.id
                    └─► Persisted to @AppStorage
                        └─► Available globally
```

## Permission Flow

```
App Launch
    │
    ├─► PhotoKit
    │   │
    │   ├─► Check PHPhotoLibrary.authorizationStatus()
    │   │
    │   ├─► If .notDetermined
    │   │   └─► PHPhotoLibrary.requestAuthorization()
    │   │       └─► Show system permission alert
    │   │           ├─► User allows → .authorized
    │   │           └─► User denies → .denied
    │   │
    │   └─► If .denied
    │       └─► Show "Allow in Settings" button
    │
    └─► MusicKit
        │
        ├─► Check MusicAuthorization.currentStatus
        │
        ├─► If .notDetermined
        │   └─► await MusicAuthorization.request()
        │       └─► Show system permission alert
        │           ├─► User allows → .authorized
        │           └─► User denies → .denied
        │
        └─► If .denied
            └─► Show "Allow in Settings" message
```

## Kiosk Mode Flow

```
Setup (One-time)
    │
    ├─► iPad Settings
    │   └─► Accessibility
    │       └─► Guided Access
    │           ├─► Enable toggle
    │           └─► Set passcode
    │
    └─► In Luciole app
        └─► Triple-click side button
            └─► Guided Access overlay appears
                ├─► Circle areas to disable (optional)
                └─► Tap "Start"
                    └─► App is locked
                        └─► Cannot exit or switch apps
                            └─► Cannot access Control Center

Exit Kiosk Mode
    │
    └─► Triple-click side button
        └─► Enter passcode
            └─► Tap "End"
                └─► App unlocked
```

## Error Handling Flow

```
Error Scenarios
    │
    ├─► No Photos
    │   └─► PhotoSlideshowView shows empty state
    │       └─► "Aucune photo" message
    │           └─► Prompt to configure in Settings
    │
    ├─► No Music Subscription
    │   └─► MusicKit request fails
    │       └─► Error logged to console
    │           └─► Show error message (future enhancement)
    │
    ├─► No Internet
    │   └─► Music search fails
    │       └─► Show "No connection" message
    │           └─► Retry when connection returns
    │
    └─► Permission Denied
        └─► Show authorization button
            └─► Opens Settings app
                └─► User grants permission
                    └─► Return to app
```

---

This flow diagram helps visualize how users navigate through Luciole and how data flows between components.
