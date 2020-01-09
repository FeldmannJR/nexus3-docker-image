# SonaType Nexus Repository Manager 3 Docker Image
Image based on openjdk-8 with the focus in automatization

## How it works
I was unable to find a way to automatize all the installation without to manually uploading the configuration scripts after the installation.  
This image runs a process that waits for the repository startup, than upload the scripts found in `/etc/nexus-init.d/` directory.

## Default Credentials
The default username is `admin` and the password is `admin123`, you can alter this with the groovy scripts, look at the [EXAMPLES](examples/src/main/groovy/). 

## Persist Data
All the data is stored in `/nexus-data`, just create a volume.  
Example: `docker run  -it -p 8081:8081 -v ./nexus_data:/nexus-data feldmannjr/nexus3`