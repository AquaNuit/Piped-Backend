FROM eclipse-temurin:17-jdk

WORKDIR /app

# Install Gradle manually
RUN apt update && apt install -y gradle

# Copy repository files
COPY . .

# Run Gradle to build Piped Backend
RUN gradle shadowJar

EXPOSE 8080

CMD ["java", "-jar", "build/libs/piped.jar", "--server.port=${PORT}"]
