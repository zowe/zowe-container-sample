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
# delete-cert-manager-resources.sh                                                      #
#                                                                                       #
# This script will delete all of the Certificate and Secret resources created by the    #
# zowe-api-ml helm chart                                                                #
#                                                                                       #
#########################################################################################

kubectl delete certificate api-catalog-service-certificate
kubectl delete secret api-catalog-tls
kubectl delete certificate discovery-service-certificate
kubectl delete secret discovery-tls
kubectl delete certificate gateway-service-certificate
kubectl delete secret gateway-tls
kubectl delete certificate jwt-secret-certificate
kubectl delete secret jwt-secret-tls
kubectl delete certificate zowe-ingress-tls
kubectl delete secret zowe-ingress-tls