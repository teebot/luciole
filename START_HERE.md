# 🦗 Luciole - Getting Started

Welcome! All the source code for Luciole is ready, but you need to create an Xcode project to build it.

## TL;DR - Quick Start

**Choose ONE of these methods:**

### Method 1: Automatic (If you have Homebrew) ⚡ FASTEST
```bash
brew install xcodegen
cd /Users/teebot/dev/luciol/Luciole
bash generate_xcode_project.sh
```
Then open `Luciole.xcodeproj` and run! (⌘R)

### Method 2: Manual (5-10 minutes) ✅ MOST RELIABLE
1. Open Xcode
2. File → New → Project → iOS App
3. Name it "Luciole", choose SwiftUI
4. Save to `/Users/teebot/dev/luciol/` (parent directory)
5. Follow **CREATE_PROJECT.md** for detailed steps

---

## Why is this needed?

Xcode project files (`.xcodeproj`) are complex binary/XML files that are difficult to generate manually. The most reliable way is to either:
- Use a tool like XcodeGen to generate them
- Create them through Xcode's GUI

All the Swift source code is already written and ready to go!

## What's Already Done ✅

All source files are complete:
- ✅ `LucioleApp.swift` - App entry point
- ✅ `ContentView.swift` - Navigation coordinator
- ✅ `Models/AppSettings.swift` - Settings storage
- ✅ `Views/HomeView.swift` - Home screen
- ✅ `Views/PhotoSlideshowView.swift` - Photo slideshow
- ✅ `Views/MusicPlayerView.swift` - Music player
- ✅ `Views/SettingsView.swift` - Settings screen
- ✅ `Managers/PhotoManager.swift` - Photo management
- ✅ `Managers/MusicManager.swift` - Music management
- ✅ `Info.plist` - App configuration
- ✅ `Luciole.entitlements` - Capabilities

## Detailed Instructions

### Option 1: Automatic with XcodeGen

**Step 1:** Install XcodeGen (one-time setup)
```bash
brew install xcodegen
```

**Step 2:** Generate the project
```bash
cd /Users/teebot/dev/luciol/Luciole
bash generate_xcode_project.sh
```

**Step 3:** Open and configure
1. Open `Luciole.xcodeproj`
2. Select the Luciole target
3. Go to "Signing & Capabilities"
4. Select your Team
5. Change Bundle Identifier to `com.yourname.Luciole`
6. Press ⌘R to build and run!

### Option 2: Manual in Xcode

**Full step-by-step guide:** See `CREATE_PROJECT.md`

**Quick version:**
1. Xcode → New Project → iOS App
2. Name: "Luciole", Interface: SwiftUI
3. Save to `/Users/teebot/dev/luciol/`
4. Delete default ContentView.swift and LucioleApp.swift
5. Right-click project → "Add Files to Luciole"
6. Add all folders: Models, Views, Managers
7. Add files: LucioleApp.swift, ContentView.swift, Info.plist, entitlements
8. Configure signing and capabilities
9. Build & Run!

## After Project Creation

Once you have the Xcode project set up:

1. **Configure Signing**
   - Select your Apple Developer team
   - Update bundle identifier

2. **Add MusicKit Capability**
   - Signing & Capabilities → + Capability → Apple Music
   - Register in Apple Developer Portal

3. **Build and Run**
   - Connect iPad or use simulator
   - Press ⌘R to run
   - Grant permissions when prompted

4. **Configure the App**
   - Open Settings (gear icon)
   - Select a photo album
   - Search for a music playlist

## File Structure

```
Luciole/
├── START_HERE.md          ← You are here!
├── CREATE_PROJECT.md      ← Detailed manual setup guide
├── README.md              ← Full app documentation
├── SETUP.md               ← Post-creation setup guide
├── PROJECT_STRUCTURE.md   ← Code architecture
├── APP_FLOW.md            ← Navigation flow diagrams
├── project.yml            ← XcodeGen configuration
├── setup_project.sh       ← File verification script
├── generate_xcode_project.sh  ← Auto-generate script
└── Luciole/
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

## Verification Script

To verify all files are in place:
```bash
cd /Users/teebot/dev/luciol/Luciole
bash setup_project.sh
```

## Troubleshooting

### "XcodeGen not found"
Install it: `brew install xcodegen`

### "Cannot find Homebrew"
Install Homebrew first:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### "Build errors in Xcode"
- Make sure all files are added to the Luciole target
- Check File Inspector → Target Membership
- Clean build: Product → Clean Build Folder (⇧⌘K)

### "Files show as red in Xcode"
- Files might not be copied correctly
- Try "Add Files to Luciole" again with "Copy items if needed" checked

### "Signing errors"
- Add your Apple ID in Xcode → Settings → Accounts
- Select your team in Signing & Capabilities

## Need Help?

- **Project setup issues**: See `CREATE_PROJECT.md`
- **App configuration**: See `SETUP.md`
- **Understanding the code**: See `PROJECT_STRUCTURE.md`
- **Navigation flow**: See `APP_FLOW.md`
- **Full documentation**: See `README.md`

## Next Steps

After successfully creating and opening the project:

1. ✅ Build the project (⌘B)
2. ✅ Run on simulator or device (⌘R)
3. ✅ Grant photo and music permissions
4. ✅ Configure album and playlist in Settings
5. ✅ Test with your loved one
6. ✅ Enable Guided Access for kiosk mode

---

**Questions?** All documentation is in this folder!

🦗 Happy building! This app is designed to bring joy to people with dementia through familiar photos and music.
