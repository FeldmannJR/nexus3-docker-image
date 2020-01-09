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
echo "[Nexus Initialize Scripts] Nexus Api is now online, scanning for groovy files in ${NEXUS_SCRIPT_SEARCH_DIR}"
# Load the random password from the file
password=$(cat ${NEXUS_DATA}/admin.password)

# Change the password for the provided env var
bash /opt/scripts/runScript.sh "security.getSecuritySystem().changePassword(\"admin\", \"${NEXUS_ADMIN_PASSWORD}\")" "$password" "--raw"
password="${NEXUS_ADMIN_PASSWORD}"

# Find init scripts

for file in `find ${NEXUS_SCRIPT_SEARCH_DIR} -type f -iname \*.groovy`
do
    if [[ -f "$file" ]]; then
        echo "[Nexus Initialize Scripts] Running $file"
        bash /opt/scripts/runScript.sh "$file" $password
    fi
done
touch "$executedFile"

