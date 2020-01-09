#!/bin/bash -e
if [ ! -d "${NEXUS_DATA}" ]; then
    mkdir -p "${NEXUS_DATA}"
fi

chown -R nexus "${NEXUS_DATA}"


exec su -s /bin/sh -c '/opt/sonatype/nexus/bin/nexus run' nexus