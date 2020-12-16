# OpenShift configuration

Most of the installation of Zowe into OpenShift is the same as Kubernetes. One noticable difference is the handling of Ingress (network traffic to Zowe from clients external to the cluster).

## Ingress using Routes

OpenShift allows the creation of *Routes* to allow external traffic to access your resources. An example script is available to create the routes for the API ML Gateway and Discovery services, in `create-routes.sh`.

**Note** Before running this script, ensure you have run the [`certificates/create-ca.sh`](../certificates/create-ca.sh) script - using instructions in [certificates/README_ca.md](../certificates/README_ca.md), or placed a `ca.crt` and `ca.key` file in `certificates/ca/` as these will be used when creating the TLS keys for use by the route. If this is not possible you will need to either a) tailor the `openshift/create-routes.sh` script to suit your needs, or b) manually create the routes.