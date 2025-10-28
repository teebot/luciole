# WeatherKit Setup Guide

WeatherKit has been added to show current time and weather on the home screen!

## What Was Added

### 1. Time Display (Upper Left)
- Shows current time in 24-hour format (HH:mm)
- Updates automatically every minute
- Large, accessible font (56pt)

### 2. Weather Display (Upper Right)
- Shows current temperature in Celsius
- Weather icon that changes based on conditions
- Fetches data from Apple's WeatherKit
- Large, accessible font (56pt)

### 3. New Files
- **WeatherManager.swift** - Manages weather data and location

### 4. Updated Files
- **HomeView.swift** - Added time and weather displays
- **Info.plist** - Added location permission
- **Luciole.entitlements** - Added WeatherKit entitlement

## Required Setup in Xcode

Since you already know about MusicKit, WeatherKit setup is similar:

### Step 1: Enable WeatherKit in Developer Portal

1. Go to [developer.apple.com](https://developer.apple.com)
2. **Certificates, Identifiers & Profiles** → **Identifiers**
3. Click on your App ID: **com.cozypixel.luciole**
4. Scroll to **App Services**
5. Check ✅ **WeatherKit**
6. Click **Save** at the top

### Step 2: Add WeatherKit Capability in Xcode

1. Open the project in Xcode
2. Select **Luciole** target
3. Go to **Signing & Capabilities**
4. Click **+ Capability**
5. Search for and add **WeatherKit**

That's it! The entitlement is already in the file.

### Step 3: Test

1. Build and run the app (⌘R)
2. When prompted, **Allow** location access
3. The home screen should show:
   - Time in upper left (e.g., "14:30")
   - Weather in upper right (e.g., "☀️ 22°")

## How It Works

### Location Permission
- WeatherKit needs your location to fetch local weather
- Uses `NSLocationWhenInUseUsageDescription` in Info.plist
- Only requests location when app is in use
- Location updates stop after getting coordinates (battery efficient)

### Weather Updates
- Fetches weather when home screen appears
- Shows temperature in Celsius
- Icon automatically matches weather conditions:
  - ☀️ Clear/Sunny
  - ☁️ Cloudy
  - 🌧️ Rainy
  - ⛈️ Thunderstorms
  - ❄️ Snow
  - 🌫️ Foggy
  - And more!

### Time Updates
- Uses 24-hour format (HH:mm)
- Updates every 60 seconds
- Always shows current time

## Weather Icons Reference

The weather manager automatically selects the appropriate SF Symbol:

| Condition | Icon |
|-----------|------|
| Clear | sun.max.fill |
| Cloudy | cloud.fill |
| Partly Cloudy | cloud.sun.fill |
| Rain | cloud.rain.fill |
| Heavy Rain | cloud.heavyrain.fill |
| Thunderstorms | cloud.bolt.rain.fill |
| Snow | cloud.snow.fill |
| Foggy | cloud.fog.fill |
| Windy | wind |
| Sleet | cloud.sleet.fill |
| Hail | cloud.hail.fill |

## Accessibility

Both time and weather use:
- ✅ Large text (56pt)
- ✅ High contrast (80% opacity on white)
- ✅ Rounded font design
- ✅ Clear spacing
- ✅ Non-intrusive placement

## Troubleshooting

### Weather shows "--"
- Location permission may be denied
- Check Settings → Privacy → Location Services
- Make sure "While Using the App" is enabled

### "WeatherKit not available"
- Ensure WeatherKit is enabled in App ID
- Check that entitlement is added
- Clean build folder: Product → Clean Build Folder (⇧⌘K)

### Wrong temperature
- WeatherKit uses device location
- Temperature is in Celsius by default
- Make sure location services are working

### Time not updating
- Should update every 60 seconds
- If stuck, go to another screen and back to home

## Privacy Notes

- Location is only used for weather
- Location data is NOT stored
- Location access is "When In Use" only
- Weather data comes directly from Apple
- No third-party services

---

**Remember**: Like MusicKit, WeatherKit doesn't actually need an entitlement in the `.entitlements` file for basic usage, but having the capability enabled in your App ID and the proper Info.plist keys is required!
