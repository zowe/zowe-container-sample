# ZLUX Dockerfiles

This directory contains Dockerfiles for a subset of the apps and plugins for the Zowe ZLUX Web Desktop.

## ZLUX App Server

`Dockerfile.zlux` contains the build information for the ZLUX application server. This assumes that a file `zlux-core-1.17.0.tar` is present in the `files/` subdirectory. Place the archive for the ZLUX app server in the `files/` directory before building the app server.

> *Note:* You may need to alter the filename in Dockerfile.zlux dependent on the actual filename

## Plugins

This directory also contains a Dockerfile for a subset of the available ZLUX plugins:
* `Dockerfile.editor` - Zowe web desktop app for editing data sets and USS files
* `Dockerfile.tn3270` - Zowe web desktop app for TN3270 emulator functionality
* `Dockerfile.vt` - Zowe web desktop app for SSH functionality
* `Dockerfile.zssauth` - authentication plugin enabling the ZLUX app server to authenticate using the ZSS Server

These assume that an archive file for the plugin (e.g. `zlux-editor-1.17.0.tar`) is present in the `files/` subdirectory. Place the archive for each plugin in the `files/` directory before building the plugin images.

> *Note:* You may need to alter the filename in the Dockerfile.<plugin> dependent on the actual filename

In addition to the plugin, the Dockerfiles will also copy the `pluginExtractor.sh` file into the container. When the each plugin container is run, the `pluginExtractor.sh` script will extract the plugin into a `/dropins` directory mounted when the container starts.

The `/dropins` directory is designed to be a Docker volume / Kubernetes Persistent Volume Claim (PVC) shared with all plugins, and the ZLUX app server. The app server is then able to install and run the extracted plugin.

Once the plugin container successfully extracts the plugin, the container will end successfully. When implemented in Kubernetes, this will allow these containers to be run within a Kubernetes `Job` resource.

## Building the images

When using the `docker-compose.yml` file in the root directory of this repository, the images will be built on first start of the Docker Compose environment.

If you want to trigger this build manually, from the root directory run:
```bash
docker-compose build
```

To manually build each of the images you can use the `docker build` command, for example:
```bash
docker build -t ompzowe/zlux-app-server:1.18 -f Dockerfile.zlux .
```

### Customising the build tag for private container registries

The `-t` flag specifies how to tag the image. If you are building this to be used in Kubernetes, or shared with other in your organisation, this tag will have to match a compatible tag for your container registry. For example, if your organisation has the container registry `containers.example.com`, and you want to place the images under the subpath `zowe`, you could use the following command:
```bash
docker build -t containers.example.com/zowe/zlux-app-server:1.18 -f Dockerfile.zlux .
```

You can then push this image to the container registry by running the command:
```bash
docker push containers.example.com/zowe/zlux-app-server:1.18
```