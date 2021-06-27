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
#########################################################################################

if [ "$1" == "org.zowe.api.catalog.json" ]; then
  echo "install app ===== $1"
  mv /app/api-catalog /dropins/api-catalog
fi

echo "Copying keystore from mounted location."
mkdir -p /app/tls/keystore
cp /app/tls/mounted-keystore/keystore.p12 /app/tls/keystore/keystore.p12

echo "Checking for JWT secret to import."
if [ -f /app/tls/jwtsecret/keystore.p12 ]; then
  echo "Found JWT secret keystore. Importing into runtime keystore."
  keytool -importkeystore -destkeystore /app/tls/keystore/keystore.p12 -deststoretype PKCS12 -deststorepass $KEYSTORE_PASSWORD -destalias jwtsecret -srckeystore /app/tls/jwtsecret/keystore.p12 -srcstoretype PKCS12 -srcstorepass $KEYSTORE_PASSWORD -srcalias 1
fi

mkdir -p /app/tls/truststore/

if [ ! -f "/app/tls/mounted-truststore/truststore.p12" ] ;
then
  echo "Creating truststore and importing CA certificate."
  openssl pkcs12 -export -nokeys -in /app/tls/mounted-keystore/ca.crt -out /app/tls/truststore/truststore.p12 -password pass:$TRUSTSTORE_PASSWORD
  keytool -import -alias zowe-ca -file /app/tls/mounted-keystore/ca.crt -keystore /app/tls/truststore/truststore.p12 -storepass $TRUSTSTORE_PASSWORD -storetype PKCS12 -noprompt
else
  echo "Skipping creation of truststore, already exists."
  echo "Copying truststore from mounted location."
  cp /app/tls/mounted-truststore/truststore.p12 /app/tls/truststore/truststore.p12
fi

if [ -d "/app/tls/trusted-certs" ] ;
then
  echo "Loading additional trusted certs."
  for filename in /app/tls/trusted-certs/*; do
    BEGINCERT="-----BEGIN CERTIFICATE-----"
    FILECONTENTS=$(head -1 $filename)
    if  [[ $FILECONTENTS == $BEGINCERT ]] ;
    then
      echo "$filename is a cert! Importing into truststore"
      keytool -import -alias $(basename "$filename" | cut -d. -f1) -file $filename -keystore /app/tls/truststore/truststore.p12 -storepass $TRUSTSTORE_PASSWORD -storetype PKCS12 -noprompt
    fi
  done
else
  echo "No additional trusted certs to load."
fi

echo "Starting Spring Boot app"
echo "Extra args: $@"
exec java -jar /app/app.jar $@