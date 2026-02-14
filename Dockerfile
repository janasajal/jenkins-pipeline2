FROM openjdk:17-jdk-slim

LABEL maintainer="your-email@example.com"

WORKDIR /app

COPY target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
