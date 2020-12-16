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
# zowe-create-secret.sh                                                                 #
#                                                                                       #
# This script will create Kubernetes secrets for each of the keystores and truststore   #
# created using the create-keystore-truststore.sh script. In addition, a Kubernetes     #
# secret will be created for each API Mediation Layer service containing the key alias  #
# and key, keystore and truststore passwords required by each service to access the     #
# keys, keystores and truststore.                                                       #
#                                                                                       #
#########################################################################################

NAMESPACE="zowe"
PASSWORD="password"

kubectl create secret generic zowe-truststore --from-file=truststore.p12 -n $NAMESPACE
kubectl create secret generic api-catalog-service-keystore --from-file=./api-catalog-service/keystore.p12 --from-file=./api-catalog-service/tls.key --from-file=./api-catalog-service/tls.crt --from-file=./api-catalog-service/ca.crt -n $NAMESPACE
kubectl create secret generic discovery-service-keystore --from-file=./discovery-service/keystore.p12 --from-file=./discovery-service/tls.key --from-file=./discovery-service/tls.crt --from-file=./discovery-service/ca.crt -n $NAMESPACE
kubectl create secret generic gateway-service-keystore --from-file=./gateway-service/keystore.p12 --from-file=./gateway-service/tls.key --from-file=./gateway-service/tls.crt --from-file=./gateway-service/ca.crt -n $NAMESPACE

kubectl create secret generic catalog-secret --from-literal=sslkeyalias=catalog --from-literal=sslkeypassword=$PASSWORD --from-literal=sslkeystorepassword=$PASSWORD --from-literal=ssltruststorepassword=$PASSWORD -n $NAMESPACE
kubectl create secret generic discovery-secret --from-literal=sslkeyalias=discovery --from-literal=sslkeypassword=$PASSWORD --from-literal=sslkeystorepassword=$PASSWORD --from-literal=ssltruststorepassword=$PASSWORD -n $NAMESPACE
kubectl create secret generic gateway-secret --from-literal=sslkeyalias=gateway --from-literal=sslkeypassword=$PASSWORD --from-literal=sslkeystorepassword=$PASSWORD --from-literal=ssltruststorepassword=$PASSWORD -n $NAMESPACE