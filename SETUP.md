# Quick Setup Guide

Follow these steps to get Luciole running on your iPad.

## Prerequisites

✅ Mac with Xcode 15+ installed
✅ iPad running iOS 16 or later
✅ Apple Developer Account
✅ Apple Music subscription (for music features)

## Step 1: Open in Xcode

1. Double-click `Luciole.xcodeproj` to open the project in Xcode
2. Wait for Xcode to index the files

## Step 2: Configure Signing

1. Select the **Luciole** project in the left sidebar
2. Select the **Luciole** target
3. Go to **Signing & Capabilities** tab
4. Select your **Team** from the dropdown
5. Xcode will automatically create a provisioning profile

## Step 3: Update Bundle Identifier

1. Change the **Bundle Identifier** to something unique:
   - Example: `com.yourname.Luciole`
2. This must match your Apple Developer account

## Step 4: Add MusicKit Capability

1. In **Signing & Capabilities**, click **+ Capability**
2. Search for and add **Apple Music**
3. This capability is required for music playback

## Step 5: Register App in Apple Developer Portal

1. Go to [developer.apple.com](https://developer.apple.com)
2. Navigate to **Certificates, Identifiers & Profiles**
3. Click **Identifiers** → **+** to add a new App ID
4. Enter your Bundle Identifier
5. Enable **MusicKit** capability
6. Save

## Step 6: Configure MusicKit

1. In the developer portal, go to **Services**
2. Click **MusicKit**
3. Click **+** to add a new MusicKit identifier
4. Select your App ID
5. Generate the identifier

## Step 7: Connect Your iPad

1. Connect your iPad to your Mac via USB-C/Lightning
2. Unlock your iPad
3. Trust the computer if prompted
4. In Xcode, select your iPad from the device dropdown (top toolbar)

## Step 8: Build and Run

1. Click the **Play** button (▶) or press **⌘ + R**
2. Wait for the app to build and install
3. On first launch, you'll be prompted to trust the developer:
   - Go to **Settings** → **General** → **VPN & Device Management**
   - Tap your developer profile
   - Tap **Trust**

## Step 9: Grant Permissions

When you first run Luciole, grant these permissions:
- ✅ **Photos**: Allow access to photo albums
- ✅ **Apple Music**: Allow access to music library

## Step 10: Configure the App

1. Tap the **gear icon** (bottom right) to open Settings
2. Select a photo album under "Album Photo"
3. Tap "Chercher une playlist" and search for a music playlist
4. Return to home and test both features

## Optional: Enable Kiosk Mode

For secure, locked operation:

1. Open iPad **Settings** → **Accessibility**
2. Scroll to **Guided Access** → Enable it
3. Tap **Passcode Settings** → Set a passcode
4. Open Luciole
5. **Triple-click** the side button
6. Tap **Start** to lock the app

To exit: Triple-click side button → Enter passcode → End

## Troubleshooting

### "Failed to register bundle identifier"
- Make sure your bundle identifier is unique
- Check that you have a valid developer account
- Try a different bundle ID

### Music won't play
- Verify you have an active Apple Music subscription
- Sign in to Apple Music on the iPad
- Check that MusicKit capability is enabled

### Photos won't load
- Grant photo permissions in Settings → Privacy
- Make sure the selected album has photos
- Try selecting a different album

### Build fails
- Clean build folder: **Product** → **Clean Build Folder** (⇧⌘K)
- Restart Xcode
- Check all files are added to the target

### App crashes on launch
- Check that all entitlements are configured
- Verify Info.plist has all required keys
- Make sure deployment target is iOS 16.0+

## Next Steps

Once everything is working:
- Configure your preferred photo album
- Choose a calming music playlist
- Adjust slideshow timing (default: 5 seconds)
- Enable Guided Access for kiosk mode
- Test with your loved one

## Support

For detailed information, see the main [README.md](README.md) file.

---

**Remember**: This app is designed for simplicity and accessibility. Test it with your loved one and adjust settings as needed.
