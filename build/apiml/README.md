# ZLUX Dockerfiles

This directory contains Dockerfiles for the Gateway, Discovery and API Catalog Services in the Zowe API Mediation Layer.

## Preparation

Before you build the container images, you will need to place the built `jar` files for the Gateway, Discovery and API Catalog services in a sub-directory named `jars/`. The Dockerfiles expect these to be called:
* API Catalog Service - `api-catalog-service.jar`
* Discovery Service - `discovery-service.jar`
* Gateway Service - `gateway-service.jar`

If the filenames for your built jar files differ, either rename the jars, or edit the `COPY` commands in each of the Dockerfiles.

## Building the images

When using the `docker-compose.yml` file in the root directory of this repository, the images will be built on first start of the Docker Compose environment.

If you want to trigger this build manually, from the root directory run:
```bash
docker-compose build
```

To manually build each of the images you can use the `docker build` command, for example:
```bash
docker build -t ompzowe/gateway-service:1.18 -f Dockerfile.gateway .
```

### Customising the build tag for private container registries

The `-t` flag specifies how to tag the image. If you are building this to be used in Kubernetes, or shared with other in your organisation, this tag will have to match a compatible tag for your container registry. For example, if your organisation has the container registry `containers.example.com`, and you want to place the images under the subpath `zowe`, you could use the following command:
```bash
docker build -t containers.example.com/zowe/gateway-service:1.18 -f Dockerfile.gateway .
```

You can then push this image to the container registry by running the command:
```bash
docker push containers.example.com/zowe/gateway-service:1.18
```

Refer to [charts/README.md](../../charts/README.md) to customise the Helm install of the API Mediation Layer to pull from your private container registry.