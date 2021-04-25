#!/bin/bash

################################################################################
# This program and the accompanying materials are made available under the terms of the
# Eclipse Public License v2.0 which accompanies this distribution, and is available at
# https://www.eclipse.org/legal/epl-v20.html
#
# SPDX-License-Identifier: EPL-2.0
#
# Copyright IBM Corporation 2018, 2020
################################################################################

################################################################################
# Variables required on shell:
# - NODE_HOME
# - ROOT_DIR
# - ZOWE_EXPLORER_FRAME_ANCESTORS
# - JES_EXPLORER_UI_PORT
# - KEYSTORE_KEY
# - KEYSTORE_CERTIFICATE
# - ZOWE_PREFIX
# - ZOWE_EXPLORER_HOST
# - ZOWE_IP_ADDRESS

# stop_jobs()
# {
#   kill -15 $pid
# }

# trap 'stop_jobs' INT


NODE_BIN=node

# cd "$ROOT_DIR/components/explorer-jes/bin"
# get current ui server directory
EXPLORER_APP_DIR="/app/explorer-app/web"
SERVER_DIR="/app/explorer-ui-server"

EXPLORER_PLUGIN_BASEURI=$($NODE_BIN -e "process.stdout.write(require('${EXPLORER_APP_DIR}/package.json').config.baseuri)")
EXPLORER_PLUGIN_NAME=$($NODE_BIN -e "process.stdout.write(require('${EXPLORER_APP_DIR}/package.json').config.pluginName)")
EXPLORER_PLUGIN_ID=$($NODE_BIN -e "process.stdout.write(require('${EXPLORER_APP_DIR}/package.json').config.pluginId)")

${EXPLORER_APP_DIR}/../bin/install-explorer-app.sh $EXPLORER_PLUGIN_ID


# JOB_NAME="${ZOWE_PREFIX}UJ"

if [ -z "${ZOWE_EXPLORER_FRAME_ANCESTORS}" ]; then
  # ZOWE_EXPLORER_FRAME_ANCESTORS="${ZOWE_EXPLORER_HOST}:*,${ZOWE_IP_ADDRESS}:*"
  ZOWE_EXPLORER_FRAME_ANCESTORS="gateway-service:*,zlux-app-server:*"
fi

# # start service
# _BPX_JOBNAME=${JOB_NAME} 
$NODE_BIN $SERVER_DIR/src/index.js \
  --service ${EXPLORER_PLUGIN_NAME} \
	--path ${EXPLORER_PLUGIN_BASEURI} \
	--dir  ${EXPLORER_APP_DIR} \
	--port ${EXPLORER_UI_PORT} \
	--key  ${KEYSTORE_KEY} \
	--cert ${KEYSTORE_CERTIFICATE} \
	--csp ${ZOWE_EXPLORER_FRAME_ANCESTORS} \
	--keyring $KEYRING_NAME \
	--keyring-owner $KEYRING_OWNER \
	--keyring-label $KEY_ALIAS \
 	-v 
# &
# pid=$?

# wait
