#!/bin/sh

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

DROPINS_DIRECTORY="/dropins"
DIRECTORY_NAME=$DROPINS_DIRECTORY/$(basename "$1" | cut -d. -f1)
mkdir -p $DIRECTORY_NAME
tar -xvf $1 -C $DIRECTORY_NAME
cd $DIRECTORY_NAME
if test -f "/dropins/bin/install-app.sh"; then
  if test -f "pluginDefinition.json"; then
    /dropins/bin/install-app.sh $DIRECTORY_NAME
  fi
fi