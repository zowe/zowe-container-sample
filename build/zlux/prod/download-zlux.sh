ZOWE_REPOSITORY=https://zowe.jfrog.io/artifactory

output=$(node getPackagePaths.js)
IFS=';'
read -a PACKAGE_URLS <<< "$output"

output=${PACKAGE_URLS[0]}
IFS=','
read -a PACKAGES <<< "$output"
# echo ${PACKAGES[*]}

output=${PACKAGE_URLS[1]}
IFS=','
read -a URLS <<< "$output"
# echo ${URLS[*]}

i=0;
for url in "${URLS[@]}";
do
  echo $i
  echo zlux/"${PACKAGES["$i"]}".tar
  curl $url -o files/zlux/"${PACKAGES["$i"]}".tar;
  i=$((i+1))
done


