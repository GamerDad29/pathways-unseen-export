#!/bin/bash

# ═══════════════════════════════════════════════════════════════
# PATHWAYS UNSEEN — DUAL PUSH SCRIPT
# GitHub + Google Drive sync in one command
# Usage: ./push.sh "your commit message"
# ═══════════════════════════════════════════════════════════════

DRIVE_PATH="/g/My Drive/Pathways Unseen Lore"
REPO_SOURCE="./Pathways Unseen"

# ── Require a commit message ────────────────────────────────────
if [ -z "$1" ]; then
  echo "❌ No commit message. Usage: ./push.sh \"your message\""
  exit 1
fi

# ── Step 1: GitHub push ─────────────────────────────────────────
echo ""
echo "⚔  Pushing to GitHub..."
git add .
git commit -m "$1"
git push

if [ $? -ne 0 ]; then
  echo "❌ GitHub push failed. Aborting Drive sync."
  exit 1
fi

echo "✓ GitHub push complete."

# ── Step 2: Mirror .md files to Google Drive ───────────────────
echo ""
echo "📖 Syncing lore to Google Drive..."

# Create Drive folder if it doesn't exist
mkdir -p "$DRIVE_PATH"

# Mirror all .md files preserving folder structure
find "$REPO_SOURCE" -name "*.md" | while read filepath; do
  # Get path relative to repo source
  relative="${filepath#$REPO_SOURCE/}"
  # Build destination path
  dest="$DRIVE_PATH/$relative"
  # Create parent directory if needed
  mkdir -p "$(dirname "$dest")"
  # Copy the file
  cp "$filepath" "$dest"
done

echo "✓ Drive sync complete."
echo ""
echo "═══════════════════════════════════════"
echo "  GitHub ✓  |  Google Drive ✓"
echo "  The world is written. The Gem knows."
echo "═══════════════════════════════════════"
echo ""
