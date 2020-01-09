#!/bin/sh

# fail if anything errors
set -e

host=http://localhost:8081
username=admin

envsubstKeep(){
    #https://stackoverflow.com/a/31926346
    Usage="usage: $CmdName runs envsubst, but allows '\$' to  keep variables from
        being expanded.
    With option   -sl   '\$' keeps the back-slash.
    Default is to replace  '\$' with '$'
    "

    if [[ $1 = -h ]]  ;then echo -e >&2  "$Usage" ; exit 1 ;fi
    if [[ $1 = -sl ]] ;then  sl='\'  ; shift ;fi

    sed 's/\\\$/\${EnVsUbDolR}/g' |  EnVsUbDolR=$sl\$  envsubst  "$@"    
}

name="startupScript"
file=$1
password="${2}"

if [ "$3" == "--raw" ]; then
    content="content=$file"
else
    tmpFile=$(mktemp)
    cat $file | envsubstKeep > $tmpFile
    content="content=@$tmpFile"
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
