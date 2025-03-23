# Use OpenJDK 17 as the base image
FROM openjdk:17-jdk-slim AS build

# Set working directory
WORKDIR /app

# Install required dependencies
RUN apt-get update && apt-get install -y curl unzip wget git && rm -rf /var/lib/apt/lists/*

# Clone the Piped Backend repository (if needed)
RUN git clone --depth 1 https://github.com/TeamPiped/Piped-Backend.git /app

# Change directory to backend
WORKDIR /app

# Download & Install Gradle manually (as gradlew is missing)
RUN wget https://services.gradle.org/distributions/gradle-8.5-bin.zip \
    && unzip gradle-8.5-bin.zip -d /opt/ \
    && rm gradle-8.5-bin.zip

# Set Gradle environment variables
ENV GRADLE_HOME=/opt/gradle-8.5
ENV PATH="${GRADLE_HOME}/bin:${PATH}"

# Ensure Gradle works
RUN gradle --version

# Run Gradle build (fixing any missing permissions)
RUN chmod +x gradlew || true
RUN gradle shadowJar --stacktrace || ./gradlew shadowJar --stacktrace

# Create new lightweight image for runtime
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the built JAR file from the build container
COPY --from=build /app/build/libs/piped.jar /app/piped.jar

# Expose the backend port
EXPOSE 8080

# Run the Piped Backend
CMD ["java", "-jar", "/app/piped.jar"]
