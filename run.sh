#!/bin/bash
Xvfb :99 -screen 0 1280x1024x24 &
export DISPLAY=:99
x11vnc -display :99 -nopw -forever &
java -jar app.jar
