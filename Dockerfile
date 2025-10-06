# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Install dependencies, including dos2unix to fix line endings
RUN apt-get update && apt-get install -y \
    libgtk-3-0 \
    libxtst6 \
    xvfb \
    x11vnc \
    dos2unix

# Set the working directory in the container
WORKDIR /app

# Copy the packaged "fat JAR" file into the container
COPY target/notebook-1.0-SNAPSHOT.jar app.jar

# Copy the run script into the container
COPY run.sh .

# --- SCRIPT CLEANUP ---
# 1. Remove the UTF-8 Byte Order Mark (BOM) if it exists
# 2. Convert Windows line endings (CRLF) to Unix line endings (LF)
RUN sed -i '1s/^\xEF\xBB\xBF//' run.sh && dos2unix run.sh

# Make the run script executable
RUN chmod +x run.sh

# Expose the VNC port
EXPOSE 5900

# The command to run when the container starts
CMD ["./run.sh"]
