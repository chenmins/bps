FROM chenmins/tomcat-centos:jdk7tomcat7
MAINTAINER Chenmin

ENV TOMCAT_HOME=/opt/tomcat \
    JAVA_HOME=/usr/java/jdk1.7.0_80 \
    JDBC_HOME=jdbc \
    APP_HOME=app

ADD ${JDBC_HOME}/*.jar ${TOMCAT_HOME}/lib/
COPY ${APP_HOME}/* ${TOMCAT_HOME}/webapps/
RUN cat ${TOMCAT_HOME}/webapps/bps.s* > ${TOMCAT_HOME}/webapps/bps.tar.gz && \
	cat ${TOMCAT_HOME}/webapps/workspace.s* > ${TOMCAT_HOME}/webapps/workspace.tar.gz && \
	cat ${TOMCAT_HOME}/webapps/governor.s* > ${TOMCAT_HOME}/webapps/governor.tar.gz && \
	rm ${TOMCAT_HOME}/webapps/*.s* && \
	mkdir ${TOMCAT_HOME}/webapps/bps && \
	mkdir ${TOMCAT_HOME}/webapps/workspace && \
	mkdir ${TOMCAT_HOME}/webapps/governor && \
	tar -xzvf ${TOMCAT_HOME}/webapps/bps.tar.gz -C ${TOMCAT_HOME}/webapps/bps && \
	tar -xzvf ${TOMCAT_HOME}/webapps/workspace.tar.gz -C ${TOMCAT_HOME}/webapps/workspace && \
	tar -xzvf ${TOMCAT_HOME}/webapps/governor.tar.gz -C ${TOMCAT_HOME}/webapps/governor && \
	rm ${TOMCAT_HOME}/webapps/*.gz 

ADD run.sh /opt
ADD startServer.sh /opt
ADD stopServer.sh /opt
RUN chmod 755 /opt/*.sh
RUN mkdir /opt/apps_config
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
VOLUME ["/opt/apps_config"]

EXPOSE 8080
ENTRYPOINT ["/opt/startServer.sh"]
