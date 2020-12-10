#FROM maven:3-jdk-8-alpine AS build-env

#WORKDIR /app
#COPY . /app
#RUN mvn package  --settings ./setting/settings.xml-apache

#FROM openjdk:8-jre
FROM mamohr/centos-java:jdk8
#COPY --from=build-env /app/target/*.jar /app.jar

WORKDIR /

RUN groupadd polaris && adduser -u 1200 -g polaris polaris
USER 1200

COPY target/*.jar /app.jar

# add debug port
ENV JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"
ENV SERVER_PORT 8080

EXPOSE ${SERVER_PORT}



HEALTHCHECK --interval=10s --timeout=3s \
	CMD curl -v --fail http://localhost:${SERVER_PORT} || exit 1

# 如下方法进程号是1
#ENTRYPOINT [ "/usr/local/openjdk-8/bin/java","-jar","-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005","$JAVA_OPTS","/app.jar" ]

# 造成 java进程非1号进程
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar"]


