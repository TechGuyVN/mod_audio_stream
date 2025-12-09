#!/bin/bash
# Script to fix submodule reference issue on server after rebase

echo "=== Fixing submodule reference ==="

# Go to main repo
cd /usr/src/mod_audio_stream_v3 || exit 1

# Pull latest changes
echo "Pulling latest changes..."
git pull origin main --no-rebase || git pull origin main

# Remove submodule reference if it exists
echo "Cleaning submodule..."
rm -rf libs/libwsc

# Re-initialize submodule
echo "Re-initializing submodule..."
git submodule sync
git submodule update --init --recursive --force libs/libwsc

# Go into submodule and checkout correct commit
echo "Checking out correct commit in submodule..."
cd libs/libwsc
git fetch origin
# Try to checkout the commit referenced by main repo, or fallback to main
git checkout d1af6ab || git checkout main
git pull origin main --no-rebase || git pull origin main
cd ../..

echo "=== Submodule fixed ==="
echo "Current submodule commit:"
cd libs/libwsc && git rev-parse HEAD && cd ../..

