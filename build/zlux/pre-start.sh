#!/bin/bash

#########################################################################################
#                                                                                       #
# This program and the accompanying materials are made available under the terms of the #
# Eclipse Public License v2.0 which accompanies this distribution, and is available at  #
# https://www.eclipse.org/legal/epl-v20.html                                            #
#                                                                                       #
# SPDX-License-Identifier: EPL-2.0                                                      #
#                                                                                       #
# Copyright IBM Corporation 2021                                                        #
#                                                                                       #
#########################################################################################

echo "Waiting for 10 seconds before installing plugins in /dropins"
echo "This will allow for all plugins to be extracted."
sleep 10

echo "Installing all plugins in /dropins"
for plugin in /dropins/*; do
  if [ -d "$plugin" ] ;
  then
    echo "Installing $plugin"
    ./install-app.sh $plugin
  fi
done

echo "Executing app-server.sh and transferring PID1 to that processes"
exec ./app-server.sh