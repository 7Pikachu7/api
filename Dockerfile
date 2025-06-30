# Etapa 1: Construcción con Maven y Java 17
FROM maven:3.8.7-openjdk-17 AS build

WORKDIR /app

# Copiamos los archivos necesarios para construir el proyecto
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

# Permiso para ejecutar mvnw
RUN chmod +x mvnw

# Construimos el proyecto sin correr tests
RUN ./mvnw clean package -DskipTests

# Etapa 2: Imagen liviana para correr la app
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copiamos el JAR construido en la etapa anterior
COPY --from=build /app/target/miapi-0.0.1-SNAPSHOT.jar app.jar

# Exponemos el puerto 8080 (puerto por defecto de Spring Boot)
EXPOSE 8080

# Comando para ejecutar la app
ENTRYPOINT ["java", "-jar", "app.jar"]
