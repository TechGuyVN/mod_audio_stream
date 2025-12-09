#!/bin/bash
# Script to force update submodule on server when encountering "not our ref" error

echo "=== Force updating submodule ==="

# Go to main repo
cd /usr/src/mod_audio_stream_v3 || exit 1

# Pull latest changes (ignore submodule errors)
echo "Pulling latest changes..."
git pull origin main --no-rebase 2>&1 | grep -v "not our ref" || true

# Remove submodule completely
echo "Removing old submodule..."
rm -rf libs/libwsc
rm -f .git/modules/libs/libwsc

# Re-initialize submodule
echo "Re-initializing submodule..."
git submodule sync
git submodule update --init --recursive --force libs/libwsc

# Go into submodule and ensure we're on the correct commit
echo "Checking out correct commit in submodule..."
cd libs/libwsc
git fetch origin
git checkout main
git pull origin main
cd ../..

echo "=== Submodule updated ==="
echo "Current submodule commit:"
cd libs/libwsc && git rev-parse HEAD && git log --oneline -1 && cd ../..
