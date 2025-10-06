# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Install all necessary dependencies, including wget and unzip for the SDK
RUN apt-get update && apt-get install -y \
    libgtk-3-0 \
    libxtst6 \
    xvfb \
    x11vnc \
    dos2unix \
    wget \
    unzip

# Download and unzip the JavaFX Linux SDK for Java 17
# This places the required runtime libraries in /javafx-sdk/lib
RUN mkdir -p /javafx-sdk \
    && wget -O javafx.zip https://download2.gluonhq.com/openjfx/17.0.10/openjfx-17.0.10_linux-x64_bin-sdk.zip \
    && unzip javafx.zip -d /javafx-sdk \
    && mv /javafx-sdk/javafx-sdk-17.0.10/lib /javafx-sdk/lib \
    && rm -rf /javafx-sdk/javafx-sdk-17.0.10 javafx.zip

# Set the working directory
WORKDIR /app

# Copy the fat JAR and rename it
COPY target/notebook-1.0-SNAPSHOT.jar app.jar

# Copy the run script
COPY run.sh .

# --- SCRIPT CLEANUP ---
# This prevents "exec format error" and "no such file or directory" errors
RUN sed -i '1s/^\xEF\xBB\xBF//' run.sh && dos2unix run.sh

# Make the script executable
RUN chmod +x run.sh

# Expose the VNC port
EXPOSE 5900

# Set the default command
CMD ["./run.sh"]
