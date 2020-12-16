#!/bin/bash

#########################################################################################
#                                                                                       #
# This program and the accompanying materials are made available under the terms of the #
# Eclipse Public License v2.0 which accompanies this distribution, and is available at  #
# https://www.eclipse.org/legal/epl-v20.html                                            #
#                                                                                       #
# SPDX-License-Identifier: EPL-2.0                                                      #
#                                                                                       #
# Copyright IBM Corporation 2020                                                        #
#                                                                                       #
# create-keystore-truststore.sh                                                         #
#                                                                                       #
# This script will create sample keystores and truststore for use with the Zowe API     #
# Mediation Layer, and a private key and certificate for use with the ZLUX Application  #
# Server.                                                                               #
#                                                                                       #
# IMPORTANT: This script is intended for demonstration, evaluation and quickstart       #
# purposes only. Consult your security experts to create the required certificates for  #
# production to ensure all your organisations requirements are met.                     #
#                                                                                       #
# This script does not protect the private keys with a password. Either alter the       #
# scripts to include a password, or ensure the keys are protected using alternative     #
# measures. If you are using cert-manager, you are unable to use password protection    #
# for the private key.                                                                  #
#                                                                                       #
#########################################################################################

echo "Removing all current working directories, keys, certs, keystores and truststore"
rm -rf api-catalog-service
rm -rf discovery-service
rm -rf gateway-service
rm -rf jwt-secret
rm -rf zlux-app-server
rm -f truststore.p12

sleep 3

SUBJECT="/C=UK/ST=Hampshire/L=Winchester/O=Zowe/OU=Development"
echo "Using Subject: $SUBJECT"

PASSWORD="password"

echo "Creating working directories"
mkdir api-catalog-service
mkdir discovery-service
mkdir gateway-service
mkdir jwt-secret
mkdir zlux-app-server

echo "Creating API Catalog Keystore"
openssl genrsa -out ./api-catalog-service/tls.key 2048
openssl req -new -subj "$SUBJECT/CN=Zowe API ML API Catalog Service" -key ./api-catalog-service/tls.key -out ./api-catalog-service/api-catalog-service.csr
openssl x509 -req -in ./api-catalog-service/api-catalog-service.csr -CA ./ca/ca.crt -CAkey ./ca/ca.key -CAcreateserial -out ./api-catalog-service/tls.crt -days 825 -sha256 -extfile ./config/api-catalog-service.ext
openssl pkcs12 -export -out ./api-catalog-service/keystore.p12 -inkey ./api-catalog-service/tls.key -in ./api-catalog-service/tls.crt -name catalog -password pass:$PASSWORD
cp ./ca/ca.crt ./api-catalog-service/ca.crt

echo "Creating Discovery Service Keystore"
openssl genrsa -out ./discovery-service/tls.key 2048
openssl req -new -subj "$SUBJECT/CN=Zowe API ML Discovery Service" -key ./discovery-service/tls.key -out ./discovery-service/discovery-service.csr
openssl x509 -req -in ./discovery-service/discovery-service.csr -CA ./ca/ca.crt -CAkey ./ca/ca.key -CAcreateserial -out ./discovery-service/tls.crt -days 825 -sha256 -extfile ./config/discovery-service.ext
openssl pkcs12 -export -out ./discovery-service/keystore.p12 -inkey ./discovery-service/tls.key -in ./discovery-service/tls.crt -name discovery -password pass:$PASSWORD
cp ./ca/ca.crt ./discovery-service/ca.crt

echo "Creating Gateway Service Keystore"
openssl genrsa -out ./gateway-service/tls.key 2048
openssl req -new -subj "$SUBJECT/CN=Zowe API ML Gateway Service" -key ./gateway-service/tls.key -out ./gateway-service/gateway-service.csr
openssl x509 -req -in ./gateway-service/gateway-service.csr -CA ./ca/ca.crt -CAkey ./ca/ca.key -CAcreateserial -out ./gateway-service/tls.crt -days 825 -sha256 -extfile ./config/gateway-service.ext
openssl pkcs12 -export -out ./gateway-service/keystore.p12 -inkey ./gateway-service/tls.key -in ./gateway-service/tls.crt -name gateway -password pass:$PASSWORD
cp ./ca/ca.crt ./gateway-service/ca.crt

echo "Creating JWT secret"
openssl genrsa -out ./jwt-secret/tls.key 2048
openssl req -new -subj "$SUBJECT/CN=Zowe API ML JWT Secret" -key ./jwt-secret/tls.key -out ./jwt-secret/jwt-secret.csr
openssl x509 -req -in ./jwt-secret/jwt-secret.csr -CA ./ca/ca.crt -CAkey ./ca/ca.key -CAcreateserial -out ./jwt-secret/tls.crt -days 825 -sha256 -extfile ./config/jwt-secret.ext
openssl pkcs12 -export -out ./jwt-secret/keystore.p12 -inkey ./jwt-secret/tls.key -in ./jwt-secret/tls.crt -name jwtsecret -password pass:$PASSWORD
cp ./ca/ca.crt ./jwt-secret/ca.crt

echo "Importing jwtsecret into Gateway Service keystore"
keytool -importkeystore -destkeystore ./gateway-service/keystore.p12 -deststoretype PKCS12 -deststorepass $PASSWORD -destalias jwtsecret -srckeystore ./jwt-secret/keystore.p12 -srcstoretype PKCS12 -srcstorepass $PASSWORD -srcalias jwtsecret

echo "Creating ZLUX Key and Certificate"
openssl genrsa -out ./zlux-app-server/tls.key 2048
openssl req -new -subj "$SUBJECT/CN=Zowe ZLUX Application Server" -key ./zlux-app-server/tls.key -out ./zlux-app-server/zlux-app-server.csr
openssl x509 -req -in ./zlux-app-server/zlux-app-server.csr -CA ./ca/ca.crt -CAkey ./ca/ca.key -CAcreateserial -out ./zlux-app-server/tls.crt -days 825 -sha256 -extfile ./config/zlux-app-server.ext

echo "Creating Truststore"
openssl pkcs12 -export -nokeys -in ./ca/ca.crt -out truststore.p12 -password pass:$PASSWORD
keytool -import -alias zowe-ca -file ./ca/ca.crt -keystore truststore.p12 -storepass $PASSWORD -storetype PKCS12 -noprompt

echo "Loading additional trusted certs"
for filename in ./trusted-certs/*; do
  BEGINCERT="-----BEGIN CERTIFICATE-----"
  FILECONTENTS=$(head -1 $filename)
  if  [[ $FILECONTENTS == $BEGINCERT ]] ;
  then
    echo "$filename is a cert! Importing into truststore"
    keytool -import -alias $(basename "$filename" | cut -d. -f1) -file $filename -keystore truststore.p12 -storepass $PASSWORD -storetype PKCS12 -noprompt
  fi
done