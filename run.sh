#!/bin/bash
# Start Xvfb, a virtual screen that lets GUI apps run in a headless environment
Xvfb :99 -screen 0 1280x1024x24 &

# Set the DISPLAY environment variable to point to the virtual screen
export DISPLAY=:99

# Start the VNC server, allowing connections from anywhere without a password
x11vnc -display :99 -nopw -forever &

# Run the Java application using a classpath AND the module path.
# --module-path libs: Tells Java to look for the JavaFX modules inside the libs/ folder.
# -cp "app.jar:libs/*": Tells Java to find our application code and all other libraries.
java --module-path libs --add-modules javafx.controls,javafx.fxml -cp "app.jar:libs/*" application.Main
