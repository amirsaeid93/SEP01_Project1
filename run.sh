#!/bin/bash
#set -e

#echo "Starting virtual display (Xvfb)..."
#Xvfb :99 -screen 0 1280x1024x24 &

# Wait briefly to ensure Xvfb is fully started
#sleep 2

#echo "Starting VNC server..."
#x11vnc -display :99 -nopw -forever -shared -rfbport 5900 &

#echo "Launching JavaFX application..."
# Use software rendering and specify module path for JavaFX
#java \
 # -Dprism.order=sw \
 # -Djava.awt.headless=false \
 # --module-path libs \
 # --add-modules javafx.controls,javafx.fxml \
 # -cp "app.jar:libs/*" \
 # application.Main
