FROM eclipse-temurin:17-jre
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-Xmx16m","-Dspring.profiles.active=docker","-jar","/app.jar"]