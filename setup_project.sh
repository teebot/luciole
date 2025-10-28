#!/bin/bash

# Luciole Xcode Project Setup Script
# This script helps organize files for easy import into Xcode

set -e

echo "🦗 Luciole Project Setup"
echo "======================="
echo ""

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Check if we're in the right directory
if [ ! -f "Luciole/LucioleApp.swift" ]; then
    echo "❌ Error: Cannot find Luciole/LucioleApp.swift"
    echo "Please run this script from the Luciole project root directory"
    exit 1
fi

echo "📂 Current directory: $SCRIPT_DIR"
echo ""

# Source files are in Luciole/ subdirectory
cd Luciole

echo "📁 Verifying source file structure..."

# Verify all files are in place
echo ""
echo "✅ Verifying file structure:"

check_file() {
    if [ -f "$1" ]; then
        echo "  ✓ $1"
        return 0
    else
        echo "  ✗ $1 (MISSING)"
        return 1
    fi
}

ALL_GOOD=true

# Check main files
check_file "LucioleApp.swift" || ALL_GOOD=false
check_file "ContentView.swift" || ALL_GOOD=false
check_file "Info.plist" || ALL_GOOD=false
check_file "Luciole.entitlements" || ALL_GOOD=false

# Check Models
check_file "Models/AppSettings.swift" || ALL_GOOD=false

# Check Views
check_file "Views/HomeView.swift" || ALL_GOOD=false
check_file "Views/PhotoSlideshowView.swift" || ALL_GOOD=false
check_file "Views/MusicPlayerView.swift" || ALL_GOOD=false
check_file "Views/SettingsView.swift" || ALL_GOOD=false

# Check Managers
check_file "Managers/PhotoManager.swift" || ALL_GOOD=false
check_file "Managers/MusicManager.swift" || ALL_GOOD=false

echo ""

if [ "$ALL_GOOD" = false ]; then
    echo "❌ Some files are missing. Please check the file structure."
    exit 1
fi

echo "✅ All source files present!"
echo ""
echo "📝 Next Steps:"
echo ""
echo "Option 1: Create Project in Xcode (Recommended)"
echo "  1. Open Xcode"
echo "  2. File → New → Project"
echo "  3. Choose iOS App"
echo "  4. Product Name: Luciole"
echo "  5. Interface: SwiftUI"
echo "  6. Save to: $(dirname "$SCRIPT_DIR")"
echo "  7. Follow CREATE_PROJECT.md for detailed steps"
echo ""
echo "Option 2: Use Xcode Project Generator"
echo "  Run: bash generate_xcode_project.sh"
echo ""
echo "For detailed instructions, see: CREATE_PROJECT.md"
echo ""
echo "🦗 Setup check complete!"
