# SonaType Nexus Repository Manager 3 Docker Image
Image based on openjdk-8 with the focus in automatization

## How it works
I was unable to find a way to automatize all the installation without to manually uploading the configuration scripts after the installation.  
This image runs a process that waits for the repository startup, than upload the scripts found in `/etc/nexus-init.d/` directory.

## How to use
Just copy the .groovy scripts to `/etc/nexus-init.d/` example of instruction in Dockerfile  
`ADD examples/src/main/groovy/changePassword.groovy /etc/nexus-init.d/`  
Look at script examples [HERE](examples/src/main/groovy/).

## Using Env Variables in Scripts
Because the nexus groovy container blocks the import of java.lang.System, i was unable to find a way to access env variable in scripts.  
To fix this issue i am preprocessing variables in the groovy scripts with the consequence of breaking default groovy string interpolation, you can still use groovy interpolation, but the dollar char must be escaped.  
### Example  
```groovy
// assuming there is a env variable TEST with value of "12345"
def TEST = "Testing..."

println "${TEST}"
// Prints 12345

println "\${TEST}"
// Prints Testing...

println "\\${TEST}"
// Prints ${TEST} 
```
## Environment Variables

### `NEXUS_ADMIN_PASSWORD` 
The password for the admin user. Default: `admin123` 

### `NEXUS_SCRIPT_SEARCH_DIR` 
Where the watcher will scan for groovy scripts. Default: `/etc/nexus-init.d` 

## Persist Data
All the data is stored in `/nexus-data`, just create a volume.  
Example: `docker run  -it -p 8081:8081 -v ./nexus_data:/nexus-data feldmannjr/nexus3`
