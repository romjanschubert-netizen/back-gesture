[README(1).md](https://github.com/user-attachments/files/35296571/README.1.md)
# back-gesture

Edge swipe back gesture for Quickshell (Caelestia) on Hyprland.

Swipe in from the left edge. A black bubble with a white arrow follows your finger a little on the Y axis. Past the threshold it sends `ALT+Left` to the active window.

## Install

    git clone <this repo>
    cd back-gesture
    ./install.sh

## Tweaks

In `BackGesture.qml`:

- `followFactor` how much the bubble follows your finger vertically
- `thresholdReached` pull distance needed to trigger
- animation `duration` values for smoothness
