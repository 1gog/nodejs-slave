FROM jdk:10.0.2

MAINTAINER Mirzuev Anatoliy <amirzuev@neoflex.ru>

ENV MAVEN_VERSION=3.6.0 \
    GRADLE_VERSION=5.1.1 \
    HOME=/home/jenkins \
    JAVA_HOME=/usr/java/jdk-10.0.2/ \
    PATH=$PATH:/opt/gradle/bin:/opt/maven/bin

# Install Maven
RUN cd /opt && curl -L -o mvn.tar.gz http://apache-mirror.rbc.ru/pub/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    tar -xzf mvn.tar.gz && \
    mv apache-maven-3.6.0 maven && \
    rm -f mvn.tar.gz
# Install Gradle
RUN curl -L -o gradle-${GRADLE_VERSION}-bin.zip https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip gradle-${GRADLE_VERSION}-bin.zip -d /opt && \
    rm -f gradle-${GRADLE_VERSION}-bin.zip && \
    mv /opt/gradle-${GRADLE_VERSION} /opt/gradle && \
    yum clean all -y && \
    mkdir -p $HOME/.m2 && \
    mkdir -p $HOME/.gradle && \
    mkdir -p /opt/jenkins

COPY entrypoint.sh /opt/jenkins/jenkins-slave.sh

VOLUME $HOME/.m2
VOLUME $HOME/.gradle

ADD ./contrib/settings.xml $HOME/.m2/
ADD ./contrib/init.gradle $HOME/.gradle/

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

USER 1001
ENTRYPOINT ["/opt/jenkins/jenkins-slave.sh"]