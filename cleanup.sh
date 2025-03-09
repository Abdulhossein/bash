#!/bin/bash

# Function to ask for user confirmation
confirm() {
    read -p "$1 (y/n): " choice
    case "$choice" in 
        y|Y ) return 0;;
        n|N ) return 1;;
        * ) echo "Invalid input"; return 1;;
    esac
}

# Clean APT cache
if confirm "Clean APT cache?"; then
    sudo apt-get clean
    sudo apt-get autoclean
    echo "APT cache cleaned."
else
    echo "Skipping APT cache cleanup."
fi

# Remove unused packages
if confirm "Remove unused packages?"; then
    sudo apt-get autoremove
    echo "Unused packages removed."
else
    echo "Skipping removal of unused packages."
fi

# Clean /tmp directory
if confirm "Clean /tmp directory?"; then
    sudo find /tmp -type f -atime +10 -delete
    echo "/tmp directory cleaned."
else
    echo "Skipping /tmp directory cleanup."
fi

# Clear thumbnail cache
if confirm "Clear thumbnail cache?"; then
    rm -rf ~/.cache/thumbnails/*
    echo "Thumbnail cache cleared."
else
    echo "Skipping thumbnail cache cleanup."
fi

# Remove old kernels
if confirm "Remove old kernels?"; then
    sudo apt-get remove --purge $(dpkg -l | grep -E 'linux-image-[0-9]+' | awk '{print $2}' | grep -v $(uname -r))
    echo "Old kernels removed."
else
    echo "Skipping old kernel removal."
fi

echo "Cleanup script completed."
