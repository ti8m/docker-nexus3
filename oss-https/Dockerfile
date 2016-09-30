FROM       sonatype/nexus:oss
MAINTAINER ti8m forge <forge@ti8m.ch>

# Switch to user root and modify some files
# See https://books.sonatype.com/nexus-book/reference/ssl-sect-ssl-direct.html
USER root

# The first two sed statements might be obsolete because Nexus is not started using Java service wrapper.
# Instead of the wrapper a direct java call is issued, see ../oss/Dockerfile.
RUN sed -i '/wrapper.app.parameter.2/a wrapper.app.parameter.3=./conf/jetty-https.xml' /opt/sonatype/nexus/bin/jsw/conf/wrapper.conf \
 && sed -i '/wrapper.app.parameter.3/a wrapper.app.parameter.4=./conf/jetty-http-redirect-to-https.xml' /opt/sonatype/nexus/bin/jsw/conf/wrapper.conf \
 && sed -i '/application-port=/a application-port-ssl=8443' /opt/sonatype/nexus/conf/nexus.properties \
 && sed -i 's#\(<Set name="keyStore">\)\(.*\)\(</Set>\)#\1/etc/ssl/nexus/nexus-keystore.jks\3#g' /opt/sonatype/nexus/conf/jetty-https.xml \
 && sed -i 's#\(<Set name="trustStore">\)\(.*\)\(</Set>\)#\1/etc/ssl/nexus/nexus-keystore.jks\3#g' /opt/sonatype/nexus/conf/jetty-https.xml \
 && sed -i 's#\(<Set name="keyStorePassword">\)\(.*\)\(</Set>\)#\1changeit\3#g' /opt/sonatype/nexus/conf/jetty-https.xml \
 && sed -i 's#\(<Set name="keyManagerPassword">\)\(.*\)\(</Set>\)#\1changeit\3#g' /opt/sonatype/nexus/conf/jetty-https.xml \
 && sed -i 's#\(<Set name="trustStorePassword">\)\(.*\)\(</Set>\)#\1changeit\3#g' /opt/sonatype/nexus/conf/jetty-https.xml

# Switch back to user nexus
USER nexus

# Setup mount point for keystore location
ENV NEXUS_KEYSTORE /etc/ssl/nexus
VOLUME ${NEXUS_KEYSTORE}

# Fix context path
ENV CONTEXT_PATH /

# Additionally to the description on the above linked page,
# the neccessary jetty configuration files will be activated now:
ENV LAUNCHER_CONF ./conf/jetty.xml ./conf/jetty-https.xml ./conf/jetty-requestlog.xml ./conf/jetty-http-redirect-to-https.xml
