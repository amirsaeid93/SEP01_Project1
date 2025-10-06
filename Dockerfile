# Start from a full Ubuntu image to ensure all graphics libraries are present.
FROM ubuntu:22.04

# Set environment variables to allow apt-get to run without user interaction.
ENV DEBIAN_FRONTEND=noninteractive

# Update the OS and install OpenJDK 17 and the required GTK/font libraries.
# We DO NOT need xvfb or x11vnc for this method.
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    libgtk-3-0 \
    fontconfig

# Set the working directory.
WORKDIR /app

# Copy the application JAR.
COPY target/notebook-1.0-SNAPSHOT.jar app.jar

# Copy all the dependency JARs.
COPY target/libs libs/

# This is the command that will be executed when the container starts.
# It is built directly into the image, eliminating the need for run.sh.
CMD [ "java", "-Dprism.order=sw", "--module-path", "libs", "--add-modules", "javafx.controls,javafx.fxml", "-cp", "app.jar:libs/*", "application.Main" ]
