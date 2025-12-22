# Étape 1 : Build
FROM maven:3.9.3-eclipse-temurin-17 AS build
WORKDIR /app

# Copier seulement pom.xml pour profiter du cache
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copier le code source et compiler
COPY src ./src
RUN mvn clean package -DskipTests

# Étape 2 : Exécution
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

# Copier uniquement le JAR compilé
COPY --from=build /app/target/demo-spring-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
