#!/bin/bash
# link.sh – symlink every folder in the dotfiles directory to ~/.config

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$HOME/.config"

for dir in "$SCRIPT_DIR"/*/; do
    name="$(basename "$dir")"
    [[ "$name" == .* ]] && continue   # skip hidden folders
    ln -sf "$dir" "$TARGET_DIR/$name"
    echo "Linked $dir → $TARGET_DIR/$name"
done
