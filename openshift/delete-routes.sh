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
# delete-routes.sh                                                                      #
#                                                                                       #
# This script will delete OpenShift Routes for the API Mediation Layer Gateway Service  #
# and Discovery Service created by the create-routes.sh script.                         #
#                                                                                       #
#########################################################################################

NAMESPACE="zowe"

oc delete route discovery-service -n $NAMESPACE
oc delete route gateway-service -n $NAMESPACE