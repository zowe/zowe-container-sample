
echo "install-explorer-app $1"
mkdir -p /dropins/$1/web
cp -r /app/explorer-app/web/img /dropins/$1/web
cp -r /app/explorer-app/pluginDefinition.json /dropins/$1/pluginDefinition.json