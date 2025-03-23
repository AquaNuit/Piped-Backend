# Use OpenJDK as the base image
FROM openjdk:17-jdk-slim AS build

# Set working directory
WORKDIR /app

# Install required dependencies
RUN apt-get update && apt-get install -y curl unzip wget && rm -rf /var/lib/apt/lists/*

# Install Gradle manually (because gradlew is missing)
RUN wget https://services.gradle.org/distributions/gradle-8.5-bin.zip \
    && unzip gradle-8.5-bin.zip -d /opt/ \
    && rm gradle-8.5-bin.zip

# Set Gradle environment variables
ENV GRADLE_HOME=/opt/gradle-8.5
ENV PATH="${GRADLE_HOME}/bin:${PATH}"

# Copy all project files
COPY . .

# Build the Piped Backend using Gradle
RUN gradle shadowJar

# Start a new lightweight container for the final runtime
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the built JAR file from the build container
COPY --from=build /app/build/libs/piped.jar /app/piped.jar

# Expose port 8080
EXPOSE 8080

# Run the Piped Backend
CMD ["java", "-jar", "/app/piped.jar"]
