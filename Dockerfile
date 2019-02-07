FROM 1gog/jre:10.0.2

MAINTAINER Mirzuev Anatoliy <amirzuev@neoflex.ru>
USER 0
ENV HOME=/home/jenkins \
    JAVA_HOME=/usr/java/jre-10.0.2/bin/java


# Install system utils 
RUN yum install -y git unzip tar zip which && yum clean all -y 
RUN curl -sL https://rpm.nodesource.com/setup_8.x | bash -
RUN yum install nodejs -y && yum clean all -y
RUN yum install -y bzip2 git curl wget fontconfig freetype freetype-devel fontconfig-devel libstdc++ && yum clean all -y

RUN mkdir -p /opt/jenkins

COPY entrypoint.sh /opt/jenkins/jenkins-slave.sh
RUN chmod g+rw /etc/passwd

VOLUME $HOME

WORKDIR /home/jenkins 
RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME && \
	chown -R 1001:0 /opt/jenkins && \
	chmod -R g+rw /opt/jenkins

USER 1001
ENTRYPOINT ["/opt/jenkins/jenkins-slave.sh"]
