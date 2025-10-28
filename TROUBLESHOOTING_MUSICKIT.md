# Fixing MusicKit Provisioning Profile Issue

## Problem
"Provisioning profile doesn't include the com.apple.developer.music-kit entitlement"

This happens because the provisioning profile was created before you enabled MusicKit.

## Solution - Try These Steps in Order

### Option 1: Force Xcode to Regenerate (FASTEST)

1. In Xcode, go to **Signing & Capabilities**
2. **Uncheck** "Automatically manage signing"
3. Wait a moment
4. **Check** "Automatically manage signing" again
5. Xcode should now fetch/create a new profile with MusicKit

If that doesn't work, try Option 2.

### Option 2: Clear and Refresh Provisioning Profiles

1. In Xcode, go to **Xcode** → **Settings** (⌘,)
2. Click **Accounts** tab
3. Select your Apple ID
4. Click **Manage Certificates...**
5. Click **Download Manual Profiles** button
6. Close the window
7. Back in your project, **Signing & Capabilities**:
   - Uncheck "Automatically manage signing"
   - Check it again
8. Select your team again

### Option 3: Delete Old Profiles and Regenerate

1. Close Xcode
2. Open **Finder** → Go to this folder (⌘⇧G):
   ```
   ~/Library/MobileDevice/Provisioning Profiles
   ```
3. Find profiles for "com.cozypixel.luciole" and delete them
4. Reopen Xcode
5. Xcode will automatically create new profiles with MusicKit

### Option 4: Manual Profile in Developer Portal

If automatic signing still fails:

1. Go to [developer.apple.com](https://developer.apple.com)
2. **Certificates, Identifiers & Profiles**
3. Click **Profiles** (left sidebar)
4. Find the profile for "com.cozypixel.luciole"
5. Click **Edit**
6. Ensure your App ID (with MusicKit) is selected
7. Click **Save** / **Generate**
8. **Download** the profile
9. Double-click to install it
10. In Xcode:
    - Uncheck "Automatically manage signing"
    - Under "Provisioning Profile", select the downloaded profile

### Option 5: Verify App ID Configuration

Sometimes the App ID needs to be reconfigured:

1. Go to [developer.apple.com](https://developer.apple.com)
2. **Certificates, Identifiers & Profiles** → **Identifiers**
3. Click on your App ID: **com.cozypixel.luciole**
4. Scroll down to **App Services**
5. Ensure **MusicKit** is checked ✅
6. Click **Save** at the top
7. Go back to Xcode and try Option 1 again

### Option 6: Clean Build and Derived Data

Sometimes Xcode caches need clearing:

1. In Xcode: **Product** → **Clean Build Folder** (⇧⌘K)
2. Close Xcode
3. Delete Derived Data:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/Luciole-*
   ```
4. Reopen Xcode
5. Try building again

## Common Issues

### "App ID does not have MusicKit capability"
- Go back to developer.apple.com
- Edit your App ID
- Enable MusicKit
- Save
- Wait 5 minutes for propagation
- Try Option 1 again

### "No matching provisioning profiles found"
- Make sure you selected your Team in Signing
- Try unchecking/rechecking "Automatically manage signing"
- Ensure your Apple ID is signed in (Xcode → Settings → Accounts)

### "Unable to install..."
- Your Apple ID might not have permission
- Ensure you're part of the development team
- Check your role in App Store Connect

## Still Not Working?

### Create a New App ID
If all else fails, create a fresh App ID:

1. Go to developer.apple.com
2. Create a new App ID with a different Bundle Identifier:
   - Example: `com.cozypixel.luciole2`
3. Enable MusicKit during creation
4. In Xcode, change the Bundle Identifier to match
5. Xcode will create a new provisioning profile automatically

### Switch to Manual Signing
As a last resort:

1. In Xcode, uncheck "Automatically manage signing"
2. Create profiles manually in the developer portal
3. Download and select them in Xcode

---

**Most Common Solution**: Option 1 (toggle automatic signing) works 90% of the time!
