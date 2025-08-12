#!/bin/bash
function restoreDock(){
    if [ "$1" == "true" ]; then
        defaults write com.apple.dock autohide-delay -float 0
        killall Dock
        echo "Se aplicó autohide-delay"
    else
        defaults write com.apple.dock autohide-time-modifier -float 0.5
        killall Dock
        echo "Se restauró correctamente el Dock"
    fi
}
restoreDock "$1"
echo "Restaurando Dock..."