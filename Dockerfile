# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Install all necessary dependencies
RUN apt-get update && apt-get install -y \
    libgtk-3-0 \
    libxtst6 \
    xvfb \
    x11vnc \
    dos2unix

# Set the working directory
WORKDIR /app

# Copy the application JAR
COPY target/notebook-1.0-SNAPSHOT.jar app.jar

# Copy all the dependency JARs
COPY target/libs libs/

# Copy the run script
COPY run.sh .

# --- SCRIPT CLEANUP ---
RUN dos2unix run.sh
RUN chmod +x run.sh

# Expose the VNC port
EXPOSE 5900

# Set the default command
CMD ["./run.sh"]
