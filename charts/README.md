# Installing Zowe into Kubernetes using Helm charts

The installation of Zowe is achieved using a Helm chart. Before you can install this chart you must [install Helm v3](https://helm.sh/docs/intro/install/).

## Tailoring your installation

Default values are provided for all configuration parameters, which can be found in the `values.yaml` file within the `zowe-api-ml` chart. You may need to tailor these based on your environment and installation preferences.

To override the default values you can provide your own `values.yaml` file, passed in with the `helm install` command. Your overrides file does not need to contain all the values, only the ones you want to override.

To override the values first create a new file, outside of the chart directory. This file can be called anything, but for the remainder of this document it will be referred to as `overrides.yaml`.

### Overriding the Container Registry

If you are using a private container registry, you will need to override the default by including the following in your `overrides.yaml` file:
```yaml
image:
  repository: uk.icr.io/zowe
  # Include this if you previously created a pull secret for authenticating to your container registry
  imagePullSecrets:
    - name: zowe-pull
```

### Configuring the z/OSMF connection

In order for the API Mediation Layer to connect to, and authenticate using z/OSMF, you must configure the z/OSMF endpoint. You can do this by adding the following YAML to your `overrides.yaml` file:
```yaml
zosmf:
  instanceBaseUrls:
    - https://zosmf.mymainframe.com:32070
  gatewayUrl: api/v1
  documentationUrl: https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.3.0/com.ibm.zos.v2r3.izua700/IZUHPINFO_RESTServices.htm
```

Replace the `instanceBaseUrls` string with the location of your z/OSMF endpoint.

**Overriding the image tag**

If you wish to override the image tag, for example for development purposes, you can add the following to `overrides.yaml`:
```yaml
apiCatalogService:
  image:
    tag: "0.1.0"

discoveryService:
  image:
    tag: "0.1.0"

gatewayService:
  image:
    tag: "0.1.0"
```

### Enabling cert-manager support

If you wish to use cert-manager to dynamically request and generate certificates, you will need to add the following to `overrides.yaml`:
```yaml
security:
  useCertManager: true
```

### Specifying an alternative Issuer resource for signing certificates

*If you are using cert-manager*

By default, the API ML Helm chart will assume a cert-manager `Issuer` resource with the name `ca-issuer` exists to sign certificates. To override this, add the following to the `overrides.yaml` file under the `security` section:
```yaml
  certManager:
    issuerRef:
      name: my-different-ca-issuer
      kind: Issuer
      group: cert-manager.io
```

Similarly, if you are using a `ClusterIssuer` as opposed to a namespaced `Issuer` you can override the `kind` attribute in the above YAML.

### Specifying additional trusted certificates

If you wish to add additional trusted certificates to your truststore, you can specify these in the `overrides.yaml` file.

First, you must base64 encode the certificate:
```bash
cat mycert.crt | base64
```

Copy the output of this command, along with the following configuration, into `overrides.yaml`:
```yaml
security:
  trustedCerts:
    mycert.crt: <BASE64 ENCODED STRING>
    mycert2.crt: <BASE64 ENCODED STRING>
```

If you have already specified a `security` section in `overrides.yaml`, append the `trustedCerts` section to the end of the `security` section, for example:
```yaml
security:
  useCertManager: true
  trustedCerts:
    mycert.crt: <BASE64 ENCODED STRING>
```

## Installing using Helm chart

After constructing your `overrides.yaml` file you are ready to install Zowe. To do this run the following commands:
```bash
helm install -f overrides.yaml myZoweRelease ./charts/zowe-api-ml
```

You can change `myZoweRelease` to any meaningful name, for example `zowe-devplex`.

## Removing an installation

To remove the installation, issue the `helm uninstall` command:
```bash
helm uninstall myZoweRelease
```