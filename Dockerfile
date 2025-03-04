FROM alpine:latest AS build

RUN apk upgrade --no-cache \
    && apk add --no-cache maven openjdk17

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn -T 2C -q clean package

FROM alpine:latest

WORKDIR /app

RUN apk upgrade --no-cache \
    && apk add --no-cache curl graphviz openjdk17-jre

COPY --from=build /app /app

CMD java -jar target/visualization-service-0.2.0-SNAPSHOT.jar