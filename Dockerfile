# Use OpenJDK slim base image for smaller size
FROM openjdk:17-slim

# Set environment variables to allow apt-get to run without user interaction.
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory.
WORKDIR /app

# Install required graphics, GUI libraries, and MariaDB
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
    mariadb-server \
    mariadb-client \
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

# Copy database initialization script
COPY init-database.sql /docker-entrypoint-initdb.d/

# Set X11 display for GUI applications
ENV DISPLAY=host.docker.internal:0.0

# Database environment variables
ENV MYSQL_ROOT_PASSWORD=root
ENV MYSQL_DATABASE=notebook
ENV MYSQL_USER=appuser
ENV MYSQL_PASSWORD=password

# Expose MySQL port
EXPOSE 3306

# Initialize MariaDB and set up the database
RUN service mysql start && \
    mysql -e "CREATE DATABASE IF NOT EXISTS notebook;" && \
    mysql -e "CREATE USER IF NOT EXISTS 'appuser'@'localhost' IDENTIFIED BY 'password';" && \
    mysql -e "GRANT ALL PRIVILEGES ON notebook.* TO 'appuser'@'localhost';" && \
    mysql -e "FLUSH PRIVILEGES;" && \
    service mysql stop

# Force JavaFX to use software rendering instead of hardware acceleration
ENV JAVA_OPTS="-Dprism.order=sw -Dprism.verbose=true"

# Start MariaDB and then run the Java application
CMD sh -c 'service mysql start && java --module-path /javafx-sdk/lib --add-modules javafx.controls,javafx.fxml -Dprism.order=sw -jar app.jar'