# Use OpenJDK as the base image
FROM openjdk:17-jdk-slim AS build

# Set working directory
WORKDIR /app

# Install required dependencies
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

# Copy all project files
COPY . .

# Manually install Gradle Wrapper if not present
RUN curl -sLo gradle-wrapper.zip https://services.gradle.org/distributions/gradle-8.5-bin.zip \
    && unzip gradle-wrapper.zip -d /opt/ \
    && rm gradle-wrapper.zip

# Make sure Gradle Wrapper is executable
RUN chmod +x gradlew

# Build the Piped Backend using Gradle Wrapper
RUN ./gradlew shadowJar

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
