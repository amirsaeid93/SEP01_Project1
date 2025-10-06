# Use OpenJDK slim base image for smaller size
FROM openjdk:17-slim

# Set environment variables to allow apt-get to run without user interaction.
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory.
WORKDIR /app

# Install required graphics and GUI libraries with OpenGL support
RUN apt-get update && apt-get install -y \
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
    libgl1-mesa-dri \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Download and unzip JavaFX Linux SDK
RUN mkdir -p /javafx-sdk \
    && wget -O javafx.zip https://download2.gluonhq.com/openjfx/21.0.2/openjfx-21.0.2_linux-x64_bin-sdk.zip \
    && unzip javafx.zip -d /javafx-sdk \
    && mv /javafx-sdk/javafx-sdk-21.0.2/lib /javafx-sdk/lib \
    && rm -rf /javafx-sdk/javafx-sdk-21.0.2 javafx.zip

# Copy the application JAR and all dependencies
COPY target/notebook-1.0-SNAPSHOT.jar app.jar
COPY target/libs/ libs/

# Set X11 display for GUI applications
ENV DISPLAY=host.docker.internal:0.0

# Database environment variables
ENV DB_HOST=database
ENV DB_PORT=3306
ENV DB_NAME=studyplanner
ENV DB_USER=root
ENV DB_PASSWORD=saeidt

# Force JavaFX to use software rendering instead of hardware acceleration
ENV JAVA_OPTS="-Dprism.order=sw -Dprism.verbose=true"

# Run JavaFX app with all dependencies in classpath
CMD ["java", "--module-path", "/javafx-sdk/lib", "--add-modules", "javafx.controls,javafx.fxml", "-Dprism.order=sw", "-cp", "app.jar:libs/*", "application.Main"]