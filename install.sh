#!/usr/bin/env bash
dir="$HOME/.config/quickshell/caelestia"
mkdir -p "$dir"
cp "$(dirname "$0")/BackGesture.qml" "$dir/BackGesture.qml"

pkill -9 -x quickshell
pkill -9 -x qs
sleep 0.5
(caelestia shell -d &>/dev/null || quickshell -c caelestia &>/dev/null) &
echo "installed"
