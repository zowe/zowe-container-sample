# Certificate Authority

Before creating the keystore and truststore, or using cert-manager for automatic certificate creation in Kubernetes, you must create a local Certificate Authority (CA) to sign the new certificates. Alternatively, you can use an existing CA. If you are using an existing CA, consult your security experts to create the required certificates.

> **IMPORTANT** The scripts in this repository do not protect the local CA private key, or any other private keys with a password. Either alter the scripts to include a password, or ensure the keys are protected using alternative measures. If you are using cert-manager, you are unable to use password protection for the CA private key.

Before running the provided script, you can tailor the Certificate *Subject* by opening the `create-ca.sh` file and altering the `SUBJECT` variable.

To create a local CA using the provided scripts:
```bash
./create-ca.sh
```

This command will create a `./ca/ca.key` and `./ca/ca.crt` file used elsewhere in the configuration.