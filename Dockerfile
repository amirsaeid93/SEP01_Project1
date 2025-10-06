FROM openjdk:17-jdk-slim


RUN apt-get update && apt-get install -y \
    libgtk-3-0 \
    libxtst6 \
    xvfb \
    x11vnc \
    dos2unix


WORKDIR /app


COPY target/notebook-1.0-SNAPSHOT.jar app.jar


COPY run.sh .


RUN dos2unix run.sh


RUN chmod +x run.sh


EXPOSE 5900


CMD ["./run.sh"]
