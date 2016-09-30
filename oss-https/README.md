# sonatype/docker-nexus:oss with activated https:// access

Docker image for Sonatype Nexus OSS with activated https:// access and automated redirect to https:// if using http://

This image is based on sonatype/nexus:oss

To build:
```
# docker build .
```

To run with port 8081 (http) and 8443 (https) and keystore file located under /etc/ssl/nexus/nexus-keystore.jks:

```
# docker run -d -p 8081:8081 -p 8443:8443 --name nexus -v /etc/ssl/nexus/:/etc/ssl/nexus/ <id>
```

or to assign a random port that maps to port 8081 on the container:

```
# docker run -d -p 8081 -p 8443 --name nexus -v /etc/ssl/nexus/:/etc/ssl/nexus/ <id>
```

To determine the port that the container is listening on:

```
# docker ps nexus
```

To test:

```
$ curl http://localhost:8081/service/local/status
```

To build:

Copy the Dockerfile and do the build-

```
$ docker build --rm=true --tag=sonatype/nexus .
```


## Notes

* Default credentials are: `admin` / `admin123`

* It can take some time (2-3 minutes) for the service to launch in a
new container.  You can tail the log to determine once Nexus is ready:

```
$ docker logs -f nexus
```

* Installation of Nexus is to `/opt/sonatype/nexus`.  Notably:
  `/opt/sonatype/nexus/conf/nexus.properties` is the properties file.
  Parameters (`nexus-work` and `nexus-webapp-context-path`) definied
  here are overridden in the JVM invocation.

* A persistent directory, `/sonatype-work`, is used for configuration,
logs, and storage. This directory needs to be writable by the Nexus
process, which runs as UID 200.

* Another persistent directory, `/etc/ssl/nexus`, is used to access the 
keystore `nexus-keystore.jks`. The default password for keystores is used.

* Four environment variables can be used to control the JVM arguments

  * `CONTEXT_PATH`, passed as -Dnexus-webapp-context-path.  This is used to define the
  URL which Nexus is accessed.
  * `MAX_HEAP`, passed as -Xmx.  Defaults to `768m`.
  * `MIN_HEAP`, passed as -Xms.  Defaults to `256m`.
  * `JAVA_OPTS`.  Additional options can be passed to the JVM via this variable.
  Default: `-server -XX:MaxPermSize=192m -Djava.net.preferIPv4Stack=true`.
  * `LAUNCHER_CONF`.  A list of configuration files supplied to the
  Nexus bootstrap launcher.  
  Default: `./conf/jetty.xml ./conf/jetty-https.xml ./conf/jetty-requestlog.xml ./conf/jetty-http-redirect-to-https.xml`

  These can be used supplied at runtime to control the JVM:

  ```
  $ docker run -d -p 8081:8081 --name nexus -e MAX_HEAP=768m sonatype/nexus
  ```


### Persistent Data

There are two general approaches to handling persistent
storage requirements with Docker. See [Managing Data in
Containers](https://docs.docker.com/userguide/dockervolumes/) for
additional information.

  1. *Use a data volume container*.  Since data volumes are persistent
  until no containers use them, a container can created specifically for 
  this purpose.  This is the recommended approach.  

  ```
  $ docker run -d --name nexus-data sonatype/nexus echo "data-only container for Nexus"
  $ docker run -d -p 8081:8081 --name nexus --volumes-from nexus-data sonatype/nexus
  ```

  2. *Mount a host directory as the volume*.  This is not portable, as it
  relies on the directory existing with correct permissions on the host.
  However it can be useful in certain situations where this volume needs
  to be assigned to certain underlying storage.  

  ```
  $ mkdir /some/dir/nexus-data && chown -R 200 /some/dir/nexus-data
  $ docker run -d -p 8081:8081 --name nexus -v /some/dir/nexus-data:/sonatype-work sonatype/nexus
  ```


### Adding Nexus Plugins

Creating a docker image based on `sonatype/nexus` is the suggested
process: plugins should be expanded to `/opt/sonatype/nexus/nexus/WEB-INF/plugin-repository`.
See https://github.com/sonatype/docker-nexus/issues/9 for an example
concerning the Nexus P2 plugins.
