FROM chenmins/bps:7.5_MultiTenant
MAINTAINER Chenmin

COPY eos-server-common-7.1.3.0.jar /opt/tomcat/webapps/bps/WEB-INF/lib/eos-server-common-7.1.3.0.jar
COPY eos-server-common-7.1.3.0.jar /opt/tomcat/webapps/governor/WEB-INF/lib/eos-server-common-7.1.3.0.jar
COPY ptp-server-jdbc-5.1.3.0.jar /opt/tomcat/webapps/bps/WEB-INF/lib/ptp-server-jdbc-5.1.3.0.jar
COPY ptp-server-jdbc-5.1.3.0.jar /opt/tomcat/webapps/governor/WEB-INF/lib/ptp-server-jdbc-5.1.3.0.jar
COPY addDatasource.jsp /opt/tomcat/webapps/governor/governor/management/datasource
COPY addUniqueDatasource.jsp /opt/tomcat/webapps/governor/governor/management/datasource
COPY updateDatasource.jsp /opt/tomcat/webapps/governor/governor/management/datasource
COPY i18n.properties /opt/tomcat/webapps/governor/WEB-INF/_srv/work/system/com.primeton.governor.core/META-INF/resources/i18n
COPY i18n_en_US.properties /opt/tomcat/webapps/governor/WEB-INF/_srv/work/system/com.primeton.governor.core/META-INF/resources/i18n
COPY i18n_zh_CN.properties /opt/tomcat/webapps/governor/WEB-INF/_srv/work/system/com.primeton.governor.core/META-INF/resources/i18n
COPY DataSource.class /opt/tomcat/webapps/governor/WEB-INF/_srv/work/system/com.primeton.governor.base/com/primeton/governor/config
COPY DataSource.class /opt/tomcat/webapps/governor/WEB-INF/classes/com/primeton/governor/config
