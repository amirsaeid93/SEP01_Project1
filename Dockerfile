# Use OpenJDK slim base image for smaller size
FROM openjdk:17-slim

# Set environment variables to allow apt-get to run without user interaction.
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory.
WORKDIR /app

# Install required graphics and GUI libraries
RUN apt-get update && apt-get install -y \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libxtst6 \
    libxi6 \
    libgtk-3-0 \
    fontconfig \
    mesa-utils \
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

# Copy all the dependency JARs (optional - if you still want to keep local libs)
COPY target/libs libs/

# Set X11 display for GUI applications
ENV DISPLAY=host.docker.internal:0.0

# Run JavaFX app using the downloaded JavaFX SDK
CMD ["java", "--module-path", "/javafx-sdk/lib", "--add-modules", "javafx.controls,javafx.fxml", "-cp", "app.jar", "your.package.Main"]