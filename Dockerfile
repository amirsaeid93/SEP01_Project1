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

# Copy the fat JAR and rename it
COPY target/notebook-1.0-SNAPSHOT.jar app.jar

# Copy the run script
COPY run.sh .

# --- SCRIPT CLEANUP ---
# This is the most important step. It removes all invisible Windows characters.
RUN sed -i '1s/^\xEF\xBB\xBF//' run.sh && dos2unix run.sh

# Make the script executable
RUN chmod +x run.sh

# Expose the VNC port
EXPOSE 5900

# Set the default command
CMD ["./run.sh"]
