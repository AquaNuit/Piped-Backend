# Use OpenJDK 17 as the base image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Download prebuilt Piped Backend JAR file (Latest version)
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/* \
    && curl -L -o piped.jar https://github.com/TeamPiped/Piped-Backend/releases/latest/download/backend.jar

# Expose the backend port
EXPOSE 8080

# Run the Piped Backend
CMD ["java", "-jar", "/app/piped.jar"]
