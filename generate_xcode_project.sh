#!/bin/bash

# Luciole Xcode Project Generator
# Generates an Xcode project using XcodeGen

set -e

echo "🦗 Luciole Xcode Project Generator"
echo "=================================="
echo ""

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Check if XcodeGen is installed
if command -v xcodegen &> /dev/null; then
    echo "✅ XcodeGen found"
    echo ""
    echo "🔨 Generating Xcode project..."
    echo ""

    xcodegen generate

    if [ -d "Luciole.xcodeproj" ]; then
        echo ""
        echo "✅ Xcode project generated successfully!"
        echo ""
        echo "📝 Next steps:"
        echo "  1. Open Luciole.xcodeproj in Xcode"
        echo "  2. Select your Team in Signing & Capabilities"
        echo "  3. Change Bundle Identifier if needed"
        echo "  4. Build and run! (⌘R)"
        echo ""
        echo "Optional: Open now?"
        read -p "Open project in Xcode? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            open Luciole.xcodeproj
        fi
    else
        echo "❌ Failed to generate project"
        exit 1
    fi
else
    echo "❌ XcodeGen not found"
    echo ""
    echo "XcodeGen is a tool that generates Xcode projects from a YAML spec."
    echo ""
    echo "Installation options:"
    echo ""
    echo "Option 1: Install via Homebrew (Recommended)"
    echo "  brew install xcodegen"
    echo ""
    echo "Option 2: Install via Mint"
    echo "  mint install yonaskolb/xcodegen"
    echo ""
    echo "Option 3: Manual Project Creation"
    echo "  Follow the guide in CREATE_PROJECT.md for step-by-step instructions"
    echo "  to create the project manually in Xcode."
    echo ""
    echo "After installing XcodeGen, run this script again."
    echo ""
    exit 1
fi
