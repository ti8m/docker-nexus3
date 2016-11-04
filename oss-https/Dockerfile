FROM       sonatype/nexus3
MAINTAINER ti8m forge <forge@ti8m.ch>

# Switch to user root and modify some files
# See https://books.sonatype.com/nexus-book/reference/ssl-sect-ssl-direct.html
USER root

# Activate https, see http://books.sonatype.com/nexus-book/3.1/reference/security.html#ssl-inbound
RUN sed -e "s/\(# \)\(nexus-args.*\)$/&\n\2,\${jetty.etc}\/jetty-https.xml,\${jetty.etc}\/jetty-http-redirect-to-https.xml/" \
        -e "\$aapplication-port-ssl=8443" \
        -i /nexus-data/etc/nexus.properties \
 && sed -e 's#\(<Set name="KeyStorePath">\)\(.*\)\(</Set>\)#\1/etc/ssl/nexus/nexus-keystore.jks\3#g' \
        -e 's#\(<Set name="TrustStorePath">\)\(.*\)\(</Set>\)#\1/etc/ssl/nexus/nexus-keystore.jks\3#g' \
        -e 's#\(<Set name="KeyStorePassword">\)\(.*\)\(</Set>\)#\1OBF:1r2x1xfn1oio1u9l1wn31u9x1oke1xff1r51\3#g' \
        -e 's#\(<Set name="TrustStorePassword">\)\(.*\)\(</Set>\)#\1OBF:1r2x1xfn1oio1u9l1wn31u9x1oke1xff1r51\3#g' \
        -e 's#\(<Set name="KeyManagerPassword">\)\(.*\)\(</Set>\)#\1OBF:1r2x1xfn1oio1u9l1wn31u9x1oke1xff1r51\3#g' \
    	-i /opt/sonatype/nexus/etc/jetty-https.xml

# Switch back to user nexus
USER nexus

# Setup mount point for keystore location
ENV NEXUS_KEYSTORE /etc/ssl/nexus
VOLUME ${NEXUS_KEYSTORE}
