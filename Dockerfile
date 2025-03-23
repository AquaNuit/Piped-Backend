# Use OpenJDK as the base image
FROM openjdk:17-jdk-slim

# Install required dependencies
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

# Install Gradle manually (since Render does not support `./gradlew`)
RUN curl -sLo gradle.zip https://services.gradle.org/distributions/gradle-8.5-bin.zip \
    && unzip gradle.zip -d /opt/ \
    && rm gradle.zip \
    && ln -s /opt/gradle-8.5/bin/gradle /usr/local/bin/gradle

# Set working directory
WORKDIR /app

# Copy all project files
COPY . .

# Build the backend using Gradle
RUN gradle shadowJar

# Expose the backend port
EXPOSE 8080

# Run the backend
CMD ["java", "-jar", "build/libs/piped.jar"]
