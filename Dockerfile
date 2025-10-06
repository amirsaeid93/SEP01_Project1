# Start from a full, standard Ubuntu operating system image.
# This is not a "slim" image and contains a much more complete set of system libraries.
FROM ubuntu:22.04

# Set environment variables to allow apt-get to run without user interaction.
ENV DEBIAN_FRONTEND=noninteractive

# Update the OS and install all necessary dependencies from scratch.
# This includes a fresh OpenJDK 17 and all known required graphics and font libraries.
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    libgtk-3-0 \
    libxtst6 \
    xvfb \
    x11vnc \
    dos2unix \
    fontconfig

# Set the working directory.
WORKDIR /app

# Copy the application JAR.
COPY target/notebook-1.0-SNAPSHOT.jar app.jar

# Copy all the dependency JARs.
COPY target/libs libs/

# Copy the run script.
COPY run.sh .

# --- SCRIPT CLEANUP ---
# Ensure the script is in the correct Linux format.
RUN dos2unix run.sh
RUN chmod +x run.sh

# Expose the VNC port.
EXPOSE 5900

# Set the default command to run our script.
CMD ["./run.sh"]
