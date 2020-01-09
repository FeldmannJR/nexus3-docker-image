# SonaType Nexus Repository Manager 3 Docker Image
Image based on openjdk-8 with the focus in automatization

## How it works
I was unable to find a way to automatize all the installation without to manually uploading the configuration scripts after the installation.  
This image runs a process that waits for the repository startup, than upload the scripts found in `/etc/nexus-init.d/` directory.

## How to use
Just copy the .groovy scripts to `/etc/nexus-init.d/` example of instruction in Dockerfile  
`ADD examples/src/main/groovy/changePassword.groovy /etc/nexus-init.d/`  
Look at script examples [HERE](examples/src/main/groovy/).

## Environment Variables

### `NEXUS_ADMIN_PASSWORD` 
The password for the user. Default: `admin123` 

## Persist Data
All the data is stored in `/nexus-data`, just create a volume.  
Example: `docker run  -it -p 8081:8081 -v ./nexus_data:/nexus-data feldmannjr/nexus3`
