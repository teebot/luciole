# Luciole - Project Structure

## Overview

Luciole is an accessible iPad app for people with dementia, featuring simple photo slideshow and music playback capabilities.

## File Structure

```
Luciole/
├── README.md                      # Main documentation
├── SETUP.md                       # Quick setup guide
├── PROJECT_STRUCTURE.md          # This file
├── Luciole.xcodeproj/
│   └── project.pbxproj           # Xcode project file
└── Luciole/
    ├── LucioleApp.swift          # App entry point
    ├── ContentView.swift         # Main coordinator view
    ├── Info.plist                # App configuration
    ├── Luciole.entitlements      # App capabilities
    ├── Models/
    │   └── AppSettings.swift     # User preferences storage
    ├── Views/
    │   ├── HomeView.swift        # Home screen with two buttons
    │   ├── PhotoSlideshowView.swift  # Photo slideshow
    │   ├── MusicPlayerView.swift     # Music player
    │   └── SettingsView.swift    # Settings screen
    └── Managers/
        ├── PhotoManager.swift    # PhotoKit integration
        └── MusicManager.swift    # MusicKit integration
```

## Key Components

### App Entry Point

**LucioleApp.swift**
- Main app structure
- Initializes AppSettings
- Hides status bar for kiosk mode
- Sets up environment

**ContentView.swift**
- Screen navigation coordinator
- Manages transitions between screens
- Handles app state

### Models

**AppSettings.swift**
- Stores selected photo album ID
- Stores selected playlist ID
- Stores slideshow interval (seconds)
- Uses @AppStorage for persistence

### Views

**HomeView.swift** (Luciole/Views/HomeView.swift)
- Large "Photos" button with thumbnail
- Large "Music" button
- Settings gear icon (bottom right)
- Loads photo thumbnail preview
- Custom ScaleButtonStyle for tactile feedback

**PhotoSlideshowView.swift** (Luciole/Views/PhotoSlideshowView.swift)
- Fullscreen photo display
- Automatic advancement (configurable interval)
- Swipe left/right navigation using TabView
- Large back button (top left)
- Preloads adjacent images for smooth transitions
- Empty state for no photos

**MusicPlayerView.swift** (Luciole/Views/MusicPlayerView.swift)
- Album artwork display
- Song title and artist
- Large play/pause button (center)
- Previous/next buttons
- Volume up/down buttons
- Large back button (top left)
- Beautiful gradient background

**SettingsView.swift** (Luciole/Views/SettingsView.swift)
- Photo album selection list
- Slideshow interval stepper (2-30 seconds)
- Apple Music playlist search
- MusicSearchView sheet for searching playlists
- Kiosk mode instructions
- Large, readable text throughout

### Managers

**PhotoManager.swift** (Luciole/Managers/PhotoManager.swift)
- Requests photo library authorization
- Loads photos from selected album
- Fetches all user albums and smart albums
- Loads high-quality images with caching
- Observable object for SwiftUI integration

**MusicManager.swift** (Luciole/Managers/MusicManager.swift)
- Singleton pattern for global music control
- Requests Apple Music authorization
- Loads and plays playlists
- Shuffles tracks automatically
- Play/pause/skip controls
- Volume control integration
- Updates current song information
- Timer for playback progress

## Features Implemented

### ✅ Core Features
- [x] Two-button home screen (Photos & Music)
- [x] Large, accessible interface
- [x] Photo slideshow with auto-advance
- [x] Swipe navigation for photos
- [x] Apple Music integration
- [x] Music playback controls
- [x] Volume controls
- [x] Settings configuration
- [x] Back buttons on all screens

### ✅ Accessibility Features
- [x] Large touch targets (80px+ buttons)
- [x] High contrast colors
- [x] Readable fonts (large sizes)
- [x] Simple navigation (max 3 screens)
- [x] Visual feedback on button press
- [x] Status bar hidden for focus
- [x] Kiosk mode support via Guided Access

### ✅ Photo Features
- [x] Album selection from photo library
- [x] Automatic slideshow (2-30 second intervals)
- [x] Swipe left/right to navigate
- [x] High-quality image loading
- [x] Image preloading for smooth transitions
- [x] Fullscreen display
- [x] Empty state handling

### ✅ Music Features
- [x] Apple Music playlist search
- [x] Random playback order
- [x] Album artwork display
- [x] Song title and artist display
- [x] Play/pause/next/previous controls
- [x] Volume up/down buttons
- [x] Background playback
- [x] Current song tracking

### ✅ Settings Features
- [x] Photo album picker
- [x] Slideshow interval configuration
- [x] Music playlist search and selection
- [x] Guided Access instructions
- [x] Permission authorization flows
- [x] Large, readable interface

## Permissions Required

### Info.plist Keys
- `NSPhotoLibraryUsageDescription`: Access photo albums
- `NSAppleMusicUsageDescription`: Access Apple Music
- `UIRequiresFullScreen`: iPad fullscreen mode
- `UIStatusBarHidden`: Hide status bar

### Entitlements
- `com.apple.developer.music-kit`: MusicKit access
- `com.apple.security.application-groups`: App groups (optional)

## Technical Details

### Frameworks Used
- **SwiftUI**: UI framework
- **MusicKit**: Apple Music integration
- **PhotoKit**: Photo library access
- **AVFoundation**: Audio session management
- **MediaPlayer**: Volume control

### iOS Version
- Minimum: iOS 16.0
- Target: iPadOS 16.0+

### Device Support
- iPad only (all models)
- Portrait and landscape orientations
- Optimized for large screens

## Design Patterns

### Architecture
- MVVM (Model-View-ViewModel)
- Observable objects for state management
- Singleton for music manager (global playback)
- @AppStorage for persistent settings

### SwiftUI Features
- @State for local state
- @StateObject for owned objects
- @EnvironmentObject for shared state
- @Published for observable properties
- Async/await for async operations
- Task for concurrent operations

### Accessibility Considerations
- Large font sizes (48-72pt for titles)
- High contrast ratios
- Simple navigation flow
- Clear visual hierarchy
- Minimal cognitive load
- Forgiving interface (no destructive actions)

## Future Enhancement Ideas

### Potential Features
- [ ] Voice control ("Hey Siri, play music")
- [ ] Video playback support
- [ ] Daily calendar/schedule view
- [ ] Contact quick-dial buttons
- [ ] Medication reminders
- [ ] Simple games or puzzles
- [ ] Voice messages from family
- [ ] Activity tracking
- [ ] Weather display
- [ ] Custom themes/colors

### Technical Improvements
- [ ] Offline music support
- [ ] Photo caching strategy
- [ ] Performance optimization
- [ ] Accessibility audit
- [ ] VoiceOver support
- [ ] Dynamic type support
- [ ] Localization (multiple languages)
- [ ] iCloud sync for settings
- [ ] Family sharing for configuration
- [ ] Remote configuration via web portal

## Testing Checklist

### Manual Testing
- [ ] Photo album selection works
- [ ] Photos display correctly
- [ ] Slideshow auto-advances
- [ ] Swipe navigation works
- [ ] Music search finds playlists
- [ ] Music playback starts
- [ ] Play/pause toggles
- [ ] Next/previous skip songs
- [ ] Volume controls adjust level
- [ ] Back buttons return home
- [ ] Settings persist across launches
- [ ] Permissions request correctly
- [ ] Guided Access locks app

### Edge Cases
- [ ] Empty photo album
- [ ] No Apple Music subscription
- [ ] No internet connection
- [ ] Album deleted after selection
- [ ] Playlist removed from library
- [ ] Low memory conditions
- [ ] App backgrounded
- [ ] Audio interruptions (calls, etc.)

## Deployment Notes

### Before Submission
1. Replace bundle identifier with your own
2. Configure code signing with your team
3. Add app icon (1024x1024)
4. Configure MusicKit identifier
5. Test on physical iPad
6. Verify all permissions work
7. Test Guided Access
8. Review accessibility

### App Store Requirements
- Privacy policy URL (if collecting data)
- App Store description emphasizing accessibility
- Screenshots showing large, clear interface
- Keywords: dementia, alzheimer's, accessibility, elderly
- Category: Health & Fitness or Medical
- Age rating: 4+

## Credits

Created for families caring for loved ones with dementia.

### Technologies
- Apple SwiftUI
- MusicKit
- PhotoKit
- iOS SDK

---

Last updated: 2025
