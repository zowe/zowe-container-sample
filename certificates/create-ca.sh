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
# create-ca.sh                                                                          #
#                                                                                       #
# This script will create a sample certificate authority that can be used to            #
# demonstrate and evaluate the solutions in the repository.                             #
#                                                                                       #
# IMPORTANT: This script is intended for demonstration, evaluation and quickstart       #
# purposes only. Consult your security experts to create the required certificates for  #
# production to ensure all your organisations requirements are met.                     #
#                                                                                       #
# This script does not protect the local CA private key with a password. Either alter   #
# the scripts to include a password, or ensure the keys are protected using alternative #
# measures. If you are using cert-manager, you are unable to use password protection    #
# for the CA private key.                                                               #
#                                                                                       #
#########################################################################################

echo "Removing current CA directory, including CA private key and certificate"
rm -rf ca

sleep 3

SUBJECT="/C=UK/ST=Hampshire/L=Winchester/O=Zowe/OU=Development"
echo "Using Subject: $SUBJECT"

echo "Creating working directories"
mkdir ca

echo "Creating Certificate Authority Private Key"
openssl genrsa -out ./ca/ca.key 2048

echo "Creating Certificate Authority Root Certificate"
openssl req -x509 -new -nodes -key ./ca/ca.key -subj "$SUBJECT/CN=Zowe" -days 3650  -reqexts v3_req -extensions v3_ca -out ./ca/ca.crt -config ./config/openssl.conf