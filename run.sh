#!/bin/bash
# Start Xvfb, a virtual screen
Xvfb :99 -screen 0 1280x1024x24 &

# Set the DISPLAY environment variable
export DISPLAY=:99

# Start the VNC server
x11vnc -display :99 -nopw -forever &

# Run the Java application using the full classpath and module path.
# This is NOT using "java -jar". It is explicitly telling Java where everything is.
java -Dprism.order=sw --module-path libs --add-modules javafx.controls,javafx.fxml -cp "app.jar:libs/*" application.Main
