#!/bin/bash


basePath="/home/osboxes/dev/equifax_bundle"
bundlePath="${basePath}/bundle_api1"
bundleFile="${bundlePath}/bundle.xml"
mappingFile="${bundlePath}/mapping.xml"
defaultTemplateFile="${bundlePath}/template.properties"
customTemplateFile="${bundlePath}/env.properties"

if [ ! -d $bundlePath ]; then
    echo "Folder ${bundlePath} is missing"
    exit 1
fi
echo "Clearing workspace directory ${bundlePath}"
rm -f "${bundlePath}/bundle.xml"
rm -f "${bundlePath}/mapping.xml"
rm -f "${bundlePath}/template.properties"
echo

echo "Exporting 'Equifax Standard API - Basic Auth' to ${bundleFile}"
GatewayMigrationUtility.sh migrateOut -z devGW.properties -d ${bundleFile} --serviceName "/Equifax/Internal/Equifax Standard API - Basic Auth" --defaultAction NewOrUpdate

echo
echo "Updating mappings"
echo

GatewayMigrationUtility.sh manageMappings -b ${bundleFile} -t "SSG_KEY_ENTRY,SSG_CONNECTOR,ID_PROVIDER_CONFIG" --outputFile ${mappingFile} --action Ignore 

echo
echo "Templatizing and De-templatizing the bundle based on ${customTemplateFile}"
#GatewayMigrationUtility.sh template -b ${bundleFile} -t ${defaultTemplateFile}
./templatePartial.sh ${bundleFile} ${customTemplateFile}
echo



