#!/bin/bash
# Start Xvfb, a virtual screen that lets GUI apps run in a headless environment
Xvfb :99 -screen 0 1280x1024x24 &

# Set the DISPLAY environment variable to point to the virtual screen
export DISPLAY=:99

# Start the VNC server
x11vnc -display :99 -nopw -forever &

# Run the Java application
# -Dprism.order=sw tells JavaFX to use the software rendering pipeline, which is required in a headless environment.
java -Dprism.order=sw --module-path libs --add-modules javafx.controls,javafx.fxml -cp "app.jar:libs/*" application.Main
