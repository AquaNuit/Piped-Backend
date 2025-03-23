# Use the official Gradle image
FROM gradle:8-jdk17 AS build

WORKDIR /app

# Copy all files
COPY . .

# Give execution permissions to gradlew
RUN chmod +x gradlew

# Build the Piped backend
RUN ./gradlew shadowJar

# Use a lightweight Java image to run the final app
FROM eclipse-temurin:17-jdk

WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/build/libs/piped.jar piped.jar

# Expose the required port
EXPOSE 8080

# Start the Piped Backend
CMD ["java", "-jar", "piped.jar", "--server.port=${PORT}"]
