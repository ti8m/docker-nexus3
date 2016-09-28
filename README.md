# sonatype/docker-nexus3

Dockerfiles for Sonatype Nexus Repository Manager 3 with OpenJDK and
Red Hat Enterprise Linux 7. Made to run on the Red Hat OpenShift Container
Platform.

# Building in OpenShift

First login in to OpenShift and clone the project and OpenShift branch

```
git clone -b ose https://github.com/sonatype/docker-nexus3.git
```

## Quickstart

If you would like to run the init.sh script provided in the repository,
it will create an OpenShift project named `nexus` within your OpenShift
instance which has a pre-made template for Nexus 3.

```
cd docker-nexus3/
./init.sh
```

After using the init.sh script, browse to the OpenShift console and login.
In the nexus project, click `Add to Project` and search for Nexus. Click
create and configure to create a Nexus service. Wait until the service has
been created and the deployment is successful. A Nexus instance should now
be available on the configured service.
