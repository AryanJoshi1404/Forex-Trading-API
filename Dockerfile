# FROM adoptopenjdk/openjdk11:ubuntu
# MAINTAINER gavinklfong@gmail.com

# # install Node JS and json mock server
# RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
#     && apt-get install -y nodejs \
#     && npm install -g json-server

# COPY mock-server/mock-data.json /app/mock-data.json

# ARG JAR_FILE=target/*.jar
# COPY ${JAR_FILE} /app/app.jar
# EXPOSE 8080

# WORKDIR /app

# COPY docker-resources/entrypoint.sh /app/entrypoint.sh

# CMD ["/app/entrypoint.sh"]

# --- Stage 1: Build the app ---
FROM maven:3.9.0-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# --- Stage 2: Run the app ---
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

