# Luciole 🦗

An accessible iPad app designed for people with dementia to enjoy photos and music with a simple, intuitive interface.

## Features

- **Large, Simple Interface**: Two big buttons for Photos and Music
- **Photo Slideshow**: Automatic slideshow with configurable duration (2-30 seconds)
- **Music Player**: Apple Music integration with large playback controls
- **Swipe Navigation**: Easy left/right swipes to navigate photos
- **Volume Controls**: Big buttons to adjust volume
- **Kiosk Mode Ready**: Instructions for locking the app using iOS Guided Access
- **Accessible Design**: High contrast, large text, and intuitive controls

## Requirements

- iPad running iOS 16.0 or later
- Xcode 15.0 or later
- Apple Developer Account (for MusicKit)
- Active Apple Music subscription (for music playback)

## Setup Instructions

### 1. Create Xcode Project

1. Open Xcode and create a new project:
   - Choose "App" template
   - Product Name: **Luciole**
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Device: **iPad**

2. Set the bundle identifier (e.g., `com.yourname.Luciole`)

### 2. Add Source Files

Copy all the source files from this repository into your Xcode project:

```
Luciole/
├── LucioleApp.swift
├── ContentView.swift
├── Info.plist
├── Luciole.entitlements
├── Models/
│   └── AppSettings.swift
├── Views/
│   ├── HomeView.swift
│   ├── PhotoSlideshowView.swift
│   ├── MusicPlayerView.swift
│   └── SettingsView.swift
└── Managers/
    ├── PhotoManager.swift
    └── MusicManager.swift
```

### 3. Configure MusicKit

1. **Register for MusicKit**:
   - Go to [Apple Developer Portal](https://developer.apple.com)
   - Navigate to Certificates, Identifiers & Profiles
   - Select your App ID
   - Enable "MusicKit" capability
   - Save changes

2. **Get MusicKit Identifier**:
   - Go to "Services" in the developer portal
   - Click "MusicKit"
   - Create a new MusicKit identifier for your app
   - Note the identifier

3. **Configure Xcode**:
   - In Xcode, select your project
   - Go to "Signing & Capabilities" tab
   - Click "+ Capability"
   - Add "Apple Music"
   - Ensure the entitlements file is linked

### 4. Configure Permissions

The `Info.plist` file already includes:
- `NSPhotoLibraryUsageDescription`: Access to photo library
- `NSAppleMusicUsageDescription`: Access to Apple Music

Make sure these descriptions are appropriate for your use case.

### 5. Build and Run

1. Select your iPad device or simulator
2. Build and run the project (⌘ + R)
3. Accept photo and music permissions when prompted

## Usage Guide

### For Family Members (Setup)

1. **Configure Photo Album**:
   - Tap the settings gear icon (bottom right)
   - Under "Album Photo", select an album containing family photos
   - Adjust "Durée par photo" (photo duration) if needed

2. **Configure Music Playlist**:
   - Tap "Chercher une playlist"
   - Search for an Apple Music playlist
   - Select the playlist to use

3. **Enable Kiosk Mode** (Optional but Recommended):
   - Go to iPad Settings → Accessibility
   - Scroll to "Guided Access" and enable it
   - Set a passcode
   - In Luciole, triple-click the side button
   - This locks the app and prevents exiting

### For Users (People with Dementia)

1. **View Photos**:
   - Tap the large "Photos" button
   - Photos will automatically advance every few seconds
   - Swipe left or right to navigate manually
   - Tap the back arrow (top left) to return home

2. **Listen to Music**:
   - Tap the large "Musique" button
   - Music will start playing automatically
   - Use the large buttons to:
     - Play/Pause (center button)
     - Previous/Next song (left/right buttons)
     - Volume up/down (bottom buttons)
   - Tap the back arrow (top left) to return home

## Kiosk Mode Setup

To prevent users from exiting the app or accessing other features:

1. Open **Settings** on iPad
2. Go to **Accessibility**
3. Scroll to **Guided Access**
4. Enable **Guided Access**
5. Tap **Passcode Settings** and set a passcode
6. In Luciole, triple-click the **side button** (or home button on older iPads)
7. Tap **Start** in the top right
8. The app is now locked

To exit Guided Access:
- Triple-click the side button again
- Enter the passcode
- Tap **End**

## Accessibility Features

- **Large Touch Targets**: All buttons are sized for easy tapping
- **High Contrast**: Clear visual distinction between elements
- **Simple Navigation**: Only 2-3 screens maximum
- **No Confusing Gestures**: Only basic taps and swipes
- **Visual Feedback**: Buttons scale when pressed
- **Auto-play**: Content starts automatically to reduce confusion

## Architecture

### Views
- `HomeView`: Main screen with two large buttons
- `PhotoSlideshowView`: Fullscreen photo slideshow with auto-advance
- `MusicPlayerView`: Music player with large controls
- `SettingsView`: Configuration screen for albums and playlists

### Managers
- `PhotoManager`: Handles PhotoKit integration and album access
- `MusicManager`: Handles MusicKit integration and playback

### Models
- `AppSettings`: Stores user preferences using `@AppStorage`

## Troubleshooting

### Photos Not Showing
- Check photo library permissions in iPad Settings → Privacy → Photos
- Ensure an album is selected in Settings
- Verify the album contains photos

### Music Not Playing
- Verify you have an active Apple Music subscription
- Check Apple Music permissions
- Ensure a playlist is selected in Settings
- Test playback in the Apple Music app first

### App Crashes on Launch
- Ensure all entitlements are properly configured
- Verify MusicKit is enabled in your App ID
- Check that the bundle identifier matches your developer account

### Kiosk Mode Not Working
- Ensure Guided Access is enabled in Accessibility settings
- Verify a passcode is set for Guided Access
- Try triple-clicking slower or faster

## Future Enhancements

Potential improvements for future versions:
- Voice control for hands-free operation
- Video playback support
- Calendar integration for daily routines
- Medication reminders
- Contact quick-dial buttons
- Simple games or puzzles

## License

This project is provided as-is for personal and educational use.

## Support

For issues or questions, please consult the code comments or Apple's documentation for:
- [MusicKit Documentation](https://developer.apple.com/documentation/musickit)
- [PhotoKit Documentation](https://developer.apple.com/documentation/photokit)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)

---

Made with ❤️ for families caring for loved ones with dementia.
