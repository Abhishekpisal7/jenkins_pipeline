FROM eclipse-temurin:21-jre

WORKDIR /app

COPY java-maven/target/cwvj-devsecops-demo-1.0.0-SNAPSHOT.jar /app/app.jar

EXPOSE 8080

ENTRYPOINT [ "java", "-jar", "app.jar" ]