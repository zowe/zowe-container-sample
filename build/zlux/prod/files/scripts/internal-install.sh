cp ${TMP_DIR}/zlux/config/pinnedPlugins.json ${ZLUX_APP_SERVER}/defaults/ZLUX/pluginStorage/org.zowe.zlux.ng2desktop/ui/launchbar/plugins/ 
cp ${TMP_DIR}/zlux/config/allowedPlugins.json ${ZLUX_APP_SERVER}/defaults/ZLUX/pluginStorage/org.zowe.zlux.bootstrap/plugins/ 
cp ${TMP_DIR}/zlux/config/zluxserver.json ${ZLUX_APP_SERVER}/defaults/serverConfig/server.json 
cp -r ${TMP_DIR}/zlux/config/plugins/* ${ZLUX_APP_SERVER}/defaults/plugins