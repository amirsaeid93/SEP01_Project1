# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Install dependencies for JavaFX, a virtual screen, and a VNC server
RUN apt-get update && apt-get install -y \
    libgtk-3-0 \
    libxtst6 \
    xvfb \
    x11vnc

# Set the working directory in the container
WORKDIR /app

# Copy the packaged "fat JAR" file into the container
# The shade plugin creates a JAR with the project's name and version
COPY target/notebook-1.0-SNAPSHOT.jar app.jar

# Copy the run script into the container
COPY run.sh .

# Make the run script executable
RUN chmod +x run.sh

# Expose the VNC port so we can connect to it
EXPOSE 5900

# The command to run when the container starts
CMD ["./run.sh"]
