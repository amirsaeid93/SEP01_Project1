# Use Ubuntu base for better graphics support
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory.
WORKDIR /app

# Install Java and graphics libraries
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libxtst6 \
    libxi6 \
    libgtk-3-0 \
    fontconfig \
    mesa-utils \
    libgl1-mesa-glx \
    libglu1-mesa \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Download and unzip JavaFX Linux SDK
RUN mkdir -p /javafx-sdk \
    && wget -O javafx.zip https://download2.gluonhq.com/openjfx/21.0.2/openjfx-21.0.2_linux-x64_bin-sdk.zip \
    && unzip javafx.zip -d /javafx-sdk \
    && mv /javafx-sdk/javafx-sdk-21.0.2/lib /javafx-sdk/lib \
    && rm -rf /javafx-sdk/javafx-sdk-21.0.2 javafx.zip

# Copy the application JAR
COPY target/notebook-1.0-SNAPSHOT.jar app.jar

# Set X11 display for GUI applications
ENV DISPLAY=host.docker.internal:0.0

# Run JavaFX app with software rendering
CMD ["java", "--module-path", "/javafx-sdk/lib", "--add-modules", "javafx.controls,javafx.fxml", "-Dprism.order=sw", "-jar", "app.jar"]