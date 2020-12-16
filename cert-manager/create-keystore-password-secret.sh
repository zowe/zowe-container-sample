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
# create-keystore-password-secret.sh                                                    #
#                                                                                       #
# This script will create a Kubernetes Secret storing a password used by cert-manager   #
# to password protect keystores created by Certificate resources                        #
#                                                                                       #
#########################################################################################

PASSWORD=${1:-password}

kubectl create secret generic pkcs12-password-secret --from-literal=password=$PASSWORD