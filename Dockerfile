FROM openjdk:8-jdk
# Based on the image of shifudao
# https://github.com/shifudao/docker-nexus3/
LABEL maintainer="feldmannjunior@gmail.com"

ENV NEXUS_VERSION 3.20.1-01
ENV SONATYPE_DIR /opt/sonatype
ENV NEXUS_HOME ${SONATYPE_DIR}/nexus
ENV NEXUS_DATA /nexus-data
ENV NEXUS_CONTEXT ''
ENV SONATYPE_WORK ${SONATYPE_DIR}/sonatype-work
# Disable random password, and set the default(admin123)
ENV NEXUS_SECURITY_RANDOMPASSWORD true
ENV NEXUS_ADMIN_PASSWORD "admin123"
ENV NEXUS_SCRIPT_SEARCH_DIR "/etc/nexus-init.d/"

# Installing httpie
RUN apt update && \
    apt install -y \
        openssl \
        gettext-base \
        httpie && \
    rm -rf /var/lib/apt/lists/*

# install nexus
RUN mkdir -p /opt/sonatype/ \
  && wget https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz -O - \
  | tar zx -C "${SONATYPE_DIR}" && rm -fr ${SONATYPE_WORK} \
  && mv "${SONATYPE_DIR}/nexus-${NEXUS_VERSION}" "${NEXUS_HOME}"

## create nexus user
RUN adduser --system -u 200 --disabled-password --home "${NEXUS_DATA}" --shell /bin/false nexus
RUN mkdir -p "${NEXUS_DATA}/etc" "${NEXUS_DATA}/log" "${NEXUS_DATA}/tmp" "${SONATYPE_WORK}"
RUN ln -s ${NEXUS_DATA} ${SONATYPE_WORK}/nexus3

# Disable the configuration gui on the first login
RUN echo "nexus.onboarding.enabled=false" >> ${NEXUS_HOME}/etc/nexus-default.properties

## prevent warning: /opt/sonatype/nexus/etc/org.apache.karaf.command.acl.config.cfg (Permission denied)
RUN chown -R nexus "${NEXUS_HOME}/etc/"

# Installing s6 overlay
RUN wget https://github.com/just-containers/s6-overlay/releases/download/v1.21.8.0/s6-overlay-amd64.tar.gz -O /tmp/s6-overlay-amd64.tar.gz
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

# Coping service initializer scripts
COPY cont-init.d/ /etc/cont-init.d/
# Coping scripts for running groovy scripts
COPY opt/ /opt/scripts/

VOLUME ${NEXUS_DATA}

# Example for running a groovy script on first run, just extends the image and copy the file or mount a volume
ADD examples/src/main/groovy/createRepositories.groovy /etc/nexus-init.d/

EXPOSE 8081
WORKDIR ${NEXUS_HOME}

ENV INSTALL4J_ADD_VM_PARAMS="-Xms1200m -Xmx1200m -XX:MaxDirectMemorySize=2g -Djava.util.prefs.userRoot=${NEXUS_DATA}/javaprefs"

CMD ["/opt/scripts/entrypoint.sh"]
ENTRYPOINT ["/init"]