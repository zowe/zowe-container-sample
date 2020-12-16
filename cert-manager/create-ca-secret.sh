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
# create-ca-secret.sh                                                                   #
#                                                                                       #
# This script will create a Kubernetes Secret storing the sample Certificate Authority  #
# private key and certificate for use by cert-manager to sign Certificate resources     #
#                                                                                       #
#########################################################################################

NAMESPACE="zowe"

kubectl delete secret ca-key-pair -n $NAMESPACE
kubectl create secret tls ca-key-pair --cert='../certificates/ca/ca.crt' --key='../certificates/ca/ca.key' -n $NAMESPACE