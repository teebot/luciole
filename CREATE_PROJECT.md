# Creating the Luciole Xcode Project

Since Xcode project files are complex binary/XML hybrids, the most reliable way to create the project is through Xcode itself. Follow these steps:

## Quick Setup (5 minutes)

### Step 1: Create New Project in Xcode

1. Open **Xcode**
2. Click **File** → **New** → **Project**
3. Select **iOS** → **App**
4. Click **Next**

### Step 2: Configure Project

Fill in these details:
- **Product Name**: `Luciole`
- **Team**: Select your team
- **Organization Identifier**: `com.yourname` (or your domain)
- **Bundle Identifier**: Will auto-fill as `com.yourname.Luciole`
- **Interface**: **SwiftUI**
- **Language**: **Swift**
- **Use Core Data**: ❌ Unchecked
- **Include Tests**: ❌ Unchecked (optional)

Click **Next**

### Step 3: Save Project

1. Navigate to `/Users/teebot/dev/luciol/`
2. Name it **Luciole** (if not already named)
3. ❌ **Uncheck** "Create Git repository" (we already have one)
4. Click **Create**

### Step 4: Delete Default Files

Xcode creates some default files we don't need. In the Project Navigator:
1. Select `ContentView.swift` (the default one)
2. Press **Delete** → **Move to Trash**
3. Select `LucioleApp.swift` (the default one)
4. Press **Delete** → **Move to Trash**

### Step 5: Add Our Source Files

1. Right-click the **Luciole** folder (blue icon) in Project Navigator
2. Select **Add Files to "Luciole"...**
3. Navigate to `/Users/teebot/dev/luciol/Luciole/Luciole/`
4. Select these files (hold ⌘ to select multiple):
   - `LucioleApp.swift`
   - `ContentView.swift`
   - `Info.plist`
   - `Luciole.entitlements`
5. **Important**: Check ✅ **"Copy items if needed"**
6. Ensure **"Luciole" target is checked**
7. Click **Add**

### Step 6: Add Models Folder

1. Right-click **Luciole** folder
2. **Add Files to "Luciole"...**
3. Navigate to `/Users/teebot/dev/luciol/Luciole/Luciole/Models/`
4. Select the **Models** folder
5. ✅ Check **"Create groups"** (not folder references)
6. ✅ Check **"Copy items if needed"**
7. ✅ Check **Luciole target**
8. Click **Add**

### Step 7: Add Views Folder

1. Right-click **Luciole** folder
2. **Add Files to "Luciole"...**
3. Navigate to `/Users/teebot/dev/luciol/Luciole/Luciole/Views/`
4. Select the **Views** folder
5. ✅ **"Create groups"**
6. ✅ **"Copy items if needed"**
7. ✅ **Luciole target**
8. Click **Add**

### Step 8: Add Managers Folder

1. Right-click **Luciole** folder
2. **Add Files to "Luciole"...**
3. Navigate to `/Users/teebot/dev/luciol/Luciole/Luciole/Managers/`
4. Select the **Managers** folder
5. ✅ **"Create groups"**
6. ✅ **"Copy items if needed"**
7. ✅ **Luciole target**
8. Click **Add**

### Step 9: Configure Info.plist

1. Select the **Luciole** project (blue icon at top)
2. Select the **Luciole** target
3. Go to **Info** tab
4. Find **"Custom iOS Target Properties"** or **"Info.plist Values"**
5. Click **+** to add keys if needed, or verify our Info.plist is being used

Actually, let's set the custom Info.plist:
1. Select **Luciole** target
2. Go to **Build Settings** tab
3. Search for `info.plist`
4. Under **Packaging**, find **Info.plist File**
5. Set value to: `Luciole/Info.plist`

### Step 10: Add Entitlements

1. Select **Luciole** project → **Luciole** target
2. Go to **Signing & Capabilities** tab
3. Ensure **Code Signing** section shows your team
4. Click **+ Capability**
5. Search for and add **"Apple Music"** (this is MusicKit)
6. The entitlements file should now be recognized

If not automatically linked:
1. Go to **Build Settings**
2. Search for `entitlements`
3. Find **Code Signing Entitlements**
4. Set to: `Luciole/Luciole.entitlements`

### Step 11: Configure Build Settings

1. Select **Luciole** project → **Luciole** target
2. **General** tab:
   - **Minimum Deployments**: iOS 16.0
   - **Supported Destinations**: ✅ iPad only
   - **Device Orientation**: All checked
   - **Status Bar Style**: Default
   - ✅ **Requires full screen**: Checked

3. **Signing & Capabilities** tab:
   - Select your **Team**
   - **Bundle Identifier**: Should be `com.yourname.Luciole`
   - Ensure **"Apple Music"** capability is added

### Step 12: Verify File Structure

Your Project Navigator should look like this:

```
Luciole
├── Luciole
│   ├── LucioleApp.swift
│   ├── ContentView.swift
│   ├── Info.plist
│   ├── Luciole.entitlements
│   ├── Models
│   │   └── AppSettings.swift
│   ├── Views
│   │   ├── HomeView.swift
│   │   ├── PhotoSlideshowView.swift
│   │   ├── MusicPlayerView.swift
│   │   └── SettingsView.swift
│   └── Managers
│       ├── PhotoManager.swift
│       └── MusicManager.swift
└── Products
    └── Luciole.app
```

### Step 13: Build the Project

1. Select a simulator or device from the device dropdown (top toolbar)
2. Click **Product** → **Build** (⌘B)
3. Wait for build to complete
4. Fix any errors if they appear (usually signing related)

### Step 14: Run!

1. Click the **Play** button (▶) or press **⌘R**
2. App should launch on iPad simulator or device
3. Grant permissions when prompted

## Troubleshooting

### "Cannot find 'AppSettings' in scope"
- Ensure `AppSettings.swift` is added to the target
- Check Project Navigator → Select file → File Inspector → Target Membership should have ✅ Luciole

### "Cannot find type 'PHAsset' in scope"
- Add `import Photos` to the file (should already be there)
- Clean build folder: **Product** → **Clean Build Folder** (⇧⌘K)

### "Cannot find type 'Song' in scope"
- Add `import MusicKit` to the file (should already be there)
- Ensure MusicKit capability is added in Signing & Capabilities

### Build succeeds but files show as red
- Files might not be in the right location
- Select file → File Inspector (right sidebar) → Click folder icon under "Location"
- Navigate to correct file location

### Signing errors
- Select your Team in Signing & Capabilities
- If no team, sign in to Xcode with your Apple ID:
  - **Xcode** → **Settings** → **Accounts** → **+** → Sign in

## Alternative: Command Line Setup

If you prefer automation, I can create a script to help with setup. Let me know!

---

Once the project is set up, refer to **SETUP.md** for app configuration and **README.md** for complete documentation.
