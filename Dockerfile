FROM openjdk:17-slim


ENV DEBIAN_FRONTEND=noninteractive


WORKDIR /app


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


RUN mkdir -p /javafx-sdk \
    && wget -O javafx.zip https://download2.gluonhq.com/openjfx/21.0.2/openjfx-21.0.2_linux-x64_bin-sdk.zip \
    && unzip javafx.zip -d /javafx-sdk \
    && mv /javafx-sdk/javafx-sdk-21.0.2/lib /javafx-sdk/lib \
    && rm -rf /javafx-sdk/javafx-sdk-21.0.2 javafx.zip


COPY target/notebook-1.0-SNAPSHOT.jar app.jar


ENV DISPLAY=host.docker.internal:0.0


ENV DB_HOST=database
ENV DB_PORT=3306
ENV DB_NAME=studyplanner
ENV DB_USER=root
ENV DB_PASSWORD=saeidt


ENV JAVA_OPTS="-Dprism.order=sw -Dprism.verbose=true"


CMD ["java", "--module-path", "/javafx-sdk/lib", "--add-modules", "javafx.controls,javafx.fxml", "-Dprism.order=sw", "-jar", "app.jar"]