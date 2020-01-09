#!/bin/sh

# fail if anything errors
set -e

host=http://localhost:8081
username=admin

name="startupScript"
file=$1
password="${2}"

content="content=@$file"
if [ "$3" == "--raw" ]; then
    content="content=$file"
fi
# Delete
echo "[Nexus Initialize Scripts] Deleting old script"
curl --silent -X DELETE -u $username:$password "$host/service/rest/v1/script/$name" -H "accept: application/json"
# Add
echo "[Nexus Initialize Scripts] Uploading the script"
http \
    -a "$username:$password" \
    --ignore-stdin \
    --check-status \
    POST $host/service/rest/v1/script \
    "name=$name" \
    type=groovy \
    "$content"
# Run
echo "[Nexus Initialize Scripts] Running the script"
curl --silent --fail -X POST -u $username:$password --header "Content-Type: text/plain" "$host/service/rest/v1/script/$name/run"
