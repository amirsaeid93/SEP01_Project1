# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Install all necessary dependencies for JavaFX and VNC
RUN apt-get update && apt-get install -y \
    libgtk-3-0 \
    libxtst6 \
    xvfb \
    x11vnc \
    dos2unix \
 && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the application JAR
COPY target/notebook-1.0-SNAPSHOT.jar app.jar

# Copy all dependency JARs
COPY target/libs libs/

# Copy the run script
COPY run.sh .

# Convert and allow execution of the script
RUN dos2unix run.sh && chmod +x run.sh

# Expose the VNC port (for optional remote GUI access)
EXPOSE 5900

# Environment variables to ensure JavaFX uses software rendering
ENV DISPLAY=:99
ENV PRISM_ORDER=sw
ENV JAVA_TOOL_OPTIONS="-Dprism.order=sw -Djava.awt.headless=false"

# Run the app using the startup script
CMD ["./run.sh"]
