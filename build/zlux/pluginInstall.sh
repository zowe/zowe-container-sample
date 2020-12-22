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