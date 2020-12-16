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
# create-routes.sh                                                                      #
#                                                                                       #
# This script will create OpenShift Routes for the API Mediation Layer Gateway Service  #
# and Discovery Service.                                                                #
#                                                                                       #
# IMPORTANT: This script are intended for demonstration, evaluation and quickstart      #
# purposes only. Consult your security experts to create the required certificates for  #
# production to ensure all your organisations requirements are met.                     #
#                                                                                       #
# This script does not protect the private keys with a password.                        #
#                                                                                       #
#########################################################################################

NAMESPACE="zowe"

rm -f *.key *.csr *.crt *.p12 *.srl

sleep 3

echo "Getting OpenShift cluster route suffix"
ROUTESUFFIX=$(oc get route console -n openshift-console -o yaml|grep routerCanonicalHostname | head -1 | cut -d ' ' -f 6)
echo "OpenShift cluster route suffix = $ROUTESUFFIX"

DISCOVERYROUTEHOSTNAME="discovery-service-zowe.$ROUTESUFFIX"
GATEWAYROUTEHOSTNAME="gateway-service-zowe.$ROUTESUFFIX"
SUBJECT="/C=UK/ST=Hampshire/L=Winchester/O=Zowe/OU=Development"

echo "Creating .ext files"
sed "s/ROUTE.EXTERNAL.HOSTNAME/$DISCOVERYROUTEHOSTNAME/g" route.ext > discovery-route.ext
sed "s/ROUTE.EXTERNAL.HOSTNAME/$GATEWAYROUTEHOSTNAME/g" route.ext > gateway-route.ext

echo "Creating Discovery Service Route Key and Certificate"
openssl genrsa -out discovery-route.key 2048
openssl req -new -subj "$SUBJECT/CN=Zowe API ML Discovery Service" -key discovery-route.key -out discovery-route.csr
openssl x509 -req -in discovery-route.csr -CA ../certificates/ca/ca.crt -CAkey ../certificates/ca/ca.key -CAcreateserial -out discovery-route.crt -days 825 -sha256 -extfile discovery-route.ext

echo "Creating Gateway Service Route Key and Certificate"
openssl genrsa -out gateway-route.key 2048
openssl req -new -subj "$SUBJECT/CN=Zowe API ML Gateway Service" -key gateway-route.key -out gateway-route.csr
openssl x509 -req -in gateway-route.csr -CA ../certificates/ca/ca.crt -CAkey ../certificates/ca/ca.key -CAcreateserial -out gateway-route.crt -days 825 -sha256 -extfile gateway-route.ext

echo "Creating Discovery Service Route"
oc create route reencrypt discovery-service --hostname="$DISCOVERYROUTEHOSTNAME" --key='discovery-route.key' --cert='discovery-route.crt' --ca-cert='../certificates/ca/ca.crt' --dest-ca-cert='../certificates/ca/ca.crt' --service='discovery-service' --port='10011' --insecure-policy='Redirect' -n $NAMESPACE

echo "Creating Gateway Service Route"
oc create route reencrypt gateway-service --hostname="$GATEWAYROUTEHOSTNAME" --key='gateway-route.key' --cert='gateway-route.crt' --ca-cert='../certificates/ca/ca.crt' --dest-ca-cert='../certificates/ca/ca.crt' --service='gateway-service' --port='10010' --insecure-policy='Redirect' -n $NAMESPACE