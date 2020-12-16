# Using cert-manager for key creation

[cert-manager](https://cert-manager.io) provides a service, hosted within a Kubernetes cluster, to issue certificates to Kubernetes applications. A user has to configure an Issuer (for example a self-signed, internal CA, or through external certificate authorities such as [Let's Encrypt](https://letsencrypt.org/), HashiCorp Vault, Venafi).

To use cert-manager, it must first be installed into your Kubernetes cluster. See this documentation for doing this: https://cert-manager.io/docs/installation/

A certificate authority will need to be configured to sign the certificates created by cert-manager. If you do not already have a certificate authority, we can set up an Issuer using our own local Certificate Authority. For instructions on how to create a local CA see [certificates/README_ca.md](../certificates/README_ca.md).

Once the local CA is created, to *upload* the CA certificate and key to Kubernetes run the following command (this script assume a `ca.crt` and `ca.key` will exist in the `../certificates/ca/` directory):
```bash
./create-ca-secret.sh
```

Now the secret containing the CA private key and certificate have been created, you need to create the cert-manager `Issuer` resource.

To do this, you can apply the `issuer.yaml` file to your cluster:
```bash
kubectl apply -f issuer.yaml
```

This will create a namespaced `Issuer` with the name `ca-issuer`. The API Mediation Layer Helm chart will use this name as the default, see the *Tailoring your installation* section below for instructions on how to override this default value.

Before installing the Helm chart, you will also need to create a secret containing the password to use to protect the keystore and truststore.

The `create-keystore-password-secret.sh` script helps to create this secret. Execute the following script to create the secret:
```bash
./create-keystore-password-secret.sh
```

To use your own password (i.e. not the default), you can pass this in as an argument:
```bash
./create-keystore-password-secret.sh mySecurePassword
```

You have now done the required setup for cert-manager.