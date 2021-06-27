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
APP_TARS_PATH="./files/plugins"
APPS_DECOMPRESS_PATH='./apps'
for file in $APP_TARS_PATH/*; do
  DIRECTORY_NAME=$(basename "$file" | cut -d. -f1)
  tar -xvf $file -C $DIRECTORY_NAME
done