FROM       registry.access.redhat.com/rhel7/rhel
MAINTAINER Sonatype <cloud-ops@sonatype.com>

EXPOSE 8081

ENV NEXUS_DATA /nexus-data
ENV REPOSITORIES /repositories
ENV NEXUS_HOME /opt/sonatype/nexus

ENV NEXUS_VERSION 3.0.2-02

# Run Yum Update
RUN yum install -y java-1.8.0-openjdk-devel tar  \
  && yum clean all

# install nexus
RUN mkdir -p ${NEXUS_HOME} \
  && curl --fail --silent --location --retry 3 \
    https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz \
  | gunzip \
  | tar x -C ${NEXUS_HOME} --strip-components=1 nexus-${NEXUS_VERSION} \
  && chown -R root:root ${NEXUS_HOME}

## configure nexus runtime env
RUN sed \
    -e "s|karaf.home=.|karaf.home=${NEXUS_HOME}|g" \
    -e "s|karaf.base=.|karaf.base=${NEXUS_HOME}|g" \
    -e "s|karaf.etc=etc|karaf.etc=${NEXUS_HOME}/etc|g" \
    -e "s|java.util.logging.config.file=etc|java.util.logging.config.file=${NEXUS_HOME}/etc|g" \
    -e "s|karaf.data=data|karaf.data=${NEXUS_DATA}|g" \
    -e "s|java.io.tmpdir=data/tmp|java.io.tmpdir=${NEXUS_DATA}/tmp|g" \
    -i ${NEXUS_HOME}/bin/nexus.vmoptions

RUN useradd -r -u 200 -m -c "nexus role account" -d ${NEXUS_DATA} -s /bin/false nexus

COPY scripts/fix-permissions.sh /usr/local/bin/

RUN chmod 755 /usr/local/bin/fix-permissions.sh \
  && /usr/local/bin/fix-permissions.sh /opt/sonatype \
  && /usr/local/bin/fix-permissions.sh $REPOSITORIES \
  && /usr/local/bin/fix-permissions.sh $NEXUS_HOME/conf

VOLUME ${NEXUS_DATA}
VOLUME ${REPOSITORIES}

USER nexus
WORKDIR $NEXUS_HOME

ENV JAVA_MAX_MEM 1200m
ENV JAVA_MIN_MEM 1200m
ENV EXTRA_JAVA_OPTS ""

CMD bin/nexus run
