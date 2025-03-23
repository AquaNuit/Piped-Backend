FROM eclipse-temurin:17-jdk

WORKDIR /app

COPY . .

RUN ./gradlew shadowJar

EXPOSE 8080

CMD ["java", "-jar", "build/libs/piped.jar", "--server.port=${PORT}"]
