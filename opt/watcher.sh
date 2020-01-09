#!/bin/bash
# If already executed exit
executedFile="/nexus-data/.initScripts"
if [ -f "$executedFile" ]; then
    exit 0
fi
# Wait untli nexus is running 
until $(curl --output /dev/null --silent --head --fail http://localhost:8081/service/rest/v1/status); do
    sleep 1
done
echo "[Nexus Initialize Scripts] Nexus Api is now online, scanning for groovy files in /etc/nexus-init.d/"
# Find init scripts
for file in /etc/nexus-init.d/*.groovy
do
    if [[ -f "$file" ]]; then
        echo "[Nexus Initialize Scripts] Running $file"
        bash /opt/scripts/runScript.sh "$file"
    fi
done
touch "$executedFile"

