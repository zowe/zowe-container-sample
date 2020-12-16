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
# zowe-delete-secret.sh                                                                 #
#                                                                                       #
# This script will delete the Kubernetes Secret resources created by the                #
# zowe-create-secret.sh script                                                          #
#                                                                                       #
#########################################################################################

NAMESPACE="zowe"

kubectl delete secret zowe-truststore -n $NAMESPACE
kubectl delete secret api-catalog-service-keystore -n $NAMESPACE
kubectl delete secret discovery-service-keystore -n $NAMESPACE
kubectl delete secret gateway-service-keystore -n $NAMESPACE

kubectl delete secret catalog-secret -n $NAMESPACE
kubectl delete secret discovery-secret -n $NAMESPACE
kubectl delete secret gateway-secret -n $NAMESPACE