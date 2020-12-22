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

if [ -d "/dropins" ]; then
  cd /dropins;
  for D in */;
   do
    cd /dropins
    plugin_base="$D""opt/zowe/plugins/app-server" 
    if test -d "$plugin_base"; then
      cd $plugin_base
      for P in */;
       do
        if test -f "$P/pluginDefinition.json"; then
          /app/zlux-core/zlux-app-server/bin/install-app.sh $P
        fi
      done
    fi
  done
fi