# Zowe multi-container sample

> **IMPORTANT** All source code and examples in this repository are samples, and not intended for live test or production environments

This repository stores artifacts relating to the deployment of Zowe on container technologies and cloud platforms.

Please note, the ZLUX App Server (Web Desktop) functionality started when using Docker Compose is currently in development and will not connect to ZSS without manual intervention. This will be documented further soon.

## Docker Compose (Quickstart)

To start a Zowe environment locally, you can use Docker Compose. This will use the configuration in the `docker-compose.yml` file to start the environment.

Ensure you have created the local CA, keystore and truststore (as documented [here](./certificates/README.md)) before continuing with Docker Compose. These resources will be mounted when the containers start.

### Configure z/OSMF endpoint

To configure the connection to z/OS, you must specify your z/OSMF endpoint in `docker/apiml/api-defs/ibm-zosmf.yml`.

To do this, open `docker/apiml/api-defs/ibm-zosmf.yml`, and change the value for `services.instanceBaseUrls` to your z/OSMF endpoint.

### Starting Docker Compose environment

Once you have configured the z/OSMF endpoint, and you can issue the following command to start your environment:
```bash
docker-compose up
```

Once started, you can access the API ML Gateway service at https://localhost:10010/ and the API ML Discovery Service (Eureka dashboard) at https://localhost:10011/

## Kubernetes

Before installing Zowe, you will need to create a new namespace for the Zowe components. In your terminal issue the following commands:

**Kubernetes**
```bash
kubectl create namespace zowe
kubectl config set-context --current --namespace=zowe
```

> *Note:* If you do not run the `kubectl config set-context` command, you will need to append any kubectl command with `-n zowe`.

**Red Hat OpenShift**

If you are using Red Hat OpenShift, you can use the following command to create a new namespace (project):
```bash
oc new-project zowe
```

The `oc new-project` command automatically switches the current context namespace to the new namespace.

### Create a pull secret

If you are pulling the Zowe container images from a private authenticated container registry, you will need to add the authentication information to Kubernetes. You can do this by creating a secret with the authentication information:
```bash
kubectl create secret docker-registry zowe-pull \
  --docker-server=<REGISTRY_LOCATION> --docker-username=<REGISTRY_USERNAME> \
  --docker-password=<REGISTRY_PASSWORD> --docker-email=<REGISTRY_EMAIL>
```

For additional information see the [Kubernetes Documentation](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/).

### Kubernetes certificate configuration

Currently, the API Mediation Layer Helm chart supports two mechanisms for creating the certificates used by the API Mediation Layer. These are:
* Using [cert-manager](https://cert-manager.io) to create the certificates, passing in a reference to a cert-manager configured Certificate Authority
* Manually creating Kubernetes secrets to store the Certificates, and Certificate information, for example, passwords and key aliases

See the sections below for more information about each approach.

#### Using cert-manager

For more information about using cert-manager with Zowe, see the [cert-manager/README.md](./cert-manager/README.md) documentation.

#### Manual certificate creation

If you do not want to, or are unable to, use cert-manager to handle certificates, you can use the scripts used in the *Keystore and Truststore* section of [certificates/README.md](./certificates/README.md) file to create the Keystores and Truststore, and then create secrets containing these artefacts in Kubernetes.

> **IMPORTANT** If you are using this method, make sure you have created the keystores and truststore as described in *[certificates/README.md](./certificates/README.md) > Keystore and Truststore* before continuing.

To *upload* the keystores and truststore into a Kubernetes secret, and also create an additional secret to store the passwords and alias information, you can execute the provided `zowe-create-secret.sh` script (if you changed the default password in the `create-keystore-truststore.sh` script you will need to make this change to the `zowe-create-secret.sh` as well):
```bash
cd certificates/
./zowe-create-secret.sh
```

This will create the following resources:
* `zowe-truststore` secret containing a `truststore.p12` truststore with the local CA certificate, and any additional trusted certificates given when running the `create-keystore-truststore.sh` script.
* `api-catalog-service-keystore` secret containing a `keystore.p12` keystore with the generated key for use by the API Catalog service.
* `discovery-service-keystore` secret containing a `keystore.p12` keystore with the generated key for use by the Discovery service.
* `gateway-service-keystore` secret containing a `keystore.p12` keystore with the generated key for use by the Gateway service. This additionally contains a `jwtsecret` key for use when generating JSON Web Tokens.
* `catalog-secret` secret containing key alias (default `catalog`) and passwords to allow the API Catalog Service to access the keystore and truststore.
* `discovery-secret` secret containing key alias (default `discovery`) and passwords to allow the Discovery service to access the keystore and truststore.
* `gateway-secret` secret containing key alias (default `gateway`) and passwords to allow the Gateway service to access the keystore and truststore.

You can check these resources using the following command:
```bash
kubectl get secrets
```

### Installing Zowe

The installation of Zowe is achieved using a Helm chart. Before you can install this chart you must [install Helm v3](https://helm.sh/docs/intro/install/).

For detailed instructions on how to perform the installation, see the [charts/README.md](./charts/README.md) file.

### Ingress

How you handle ingress (allowing traffic into your cluster) will depend on your environment, some examples are given below:

#### Red Hat OpenShift

See the [openshift/README.md file](./openshift/README.md) for instructions on how to handle ingress in OpenShift.