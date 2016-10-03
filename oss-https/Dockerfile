FROM       sonatype/nexus3
MAINTAINER ti8m forge <forge@ti8m.ch>

# Switch to user root and modify some files
# See https://books.sonatype.com/nexus-book/reference/ssl-sect-ssl-direct.html
USER root

# Activate https
RUN sed -e "\$aapplication-port-ssl=8443" -e "s#\(nexus-args=.*$\)#\1,\${karaf.etc}/jetty-https.xml#g" -i /opt/sonatype/nexus/etc/org.sonatype.nexus.cfg \
 && sed -e 's#\(<Set name="KeyStorePath">\)\(.*\)\(</Set>\)#\1/etc/ssl/nexus/nexus-keystore.jks\3#g' \
        -e 's#\(<Set name="TrustStorePath">\)\(.*\)\(</Set>\)#\1/etc/ssl/nexus/nexus-keystore.jks\3#g' \
        -e 's#\(<Set name="KeyStorePassword">\)\(.*\)\(</Set>\)#\1changeit\3#g' \
        -e 's#\(<Set name="TrustStorePassword">\)\(.*\)\(</Set>\)#\1changeit\3#g' \
        -e 's#\(<Set name="KeyManagerPassword">\)\(.*\)\(</Set>\)#\1changeit\3#g' \
    	-i jetty-https.xml

# Switch back to user nexus
USER nexus

# Setup mount point for keystore location
ENV NEXUS_KEYSTORE /etc/ssl/nexus
VOLUME ${NEXUS_KEYSTORE}
