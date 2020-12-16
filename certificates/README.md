# Certificate Authority, Keystore and Truststore

If you are planning on using Docker compose, or you are using Kubernetes, but do not wish to use cert-manager to automatically create certificates used by Zowe, you will need to manually create a keystore and truststore. This repository includes sample scripts that can be used to create these resources. 

> **IMPORTANT** These scripts are intended for demonstration, evaluation and quickstart purposes only. Consult your security experts to create the required certificates for production to ensure all your organisations requirements are met.

## Certificate Authority

Before creating the keystore and truststore, you must create a local Certificate Authority (CA) to sign the new certificates. See [README_ca.md](README_ca.md) for instructions.

Alternatively, you can use an existing CA. If you are using an existing CA, consult your security experts to create the required certificates. The existing CA key and certificate would have to be placed in the `./ca/` directory.

## Keystore and Truststore

Before running the provided script, you can tailor the Certificate *Subject* by opening the `create-keystore-truststore.sh` file and altering the `SUBJECT` variable.

If you want to include additional trusted certificates (for example, for your z/OSMF instance), place these in the `trusted-certs` directory.

To create a keystore and truststore using the provided scripts:
```bash
./create-keystore-truststore.sh
```

This will create multiple `.key`, `.csr` and `.crt` files - one for each service, and an additional one for the JWT secret. All services will have their own working directory, for example `gateway-service/`. It will also create a `truststore.p12` file containing the `ca.crt` file, as well as any additional certificates that have been copied in the `trusted-certs/` directory.

Importantly, for the API Mediation Layer services, the script will also create a `.p12` keystore for each service, for example `./gateway-service/keystore.p12`.

For the ZLUX App Server component, only a `.key` and `.crt` file will be created.

Each of the newly created files will be placed in a directory for each service.

## Using the Keystore and Truststore

For Docker Compose the new keystores and truststore will automatically be pulled in when Docker Compose is started. For Kubernetes based deployment, consult the Kubernetes section of the [repository README](../README.md) for more information.