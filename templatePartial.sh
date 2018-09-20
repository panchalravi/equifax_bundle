#!/bin/bash

if [[ -z "$1" || -z "$2" ]]; then
    echo "Need to specify a bundle and template.properties: $( basename $0 ) <bundle> <template.properties>"
    exit 1
elif [ ! -e "$1" ]; then
    echo "Bundle does not exist: $1"
    exit 1   
elif [ ! -r "$1" ]; then
    echo "Cannot read bundle $1"
    exit 1
elif [ ! -e "$2" ]; then
    echo "Template properties file does not exist: $2"
    exit 1   
elif [ ! -r "$2" ]; then
    echo "Cannot read file template properties file $2"
    exit 1
fi

#scriptDir=$(dirname $0)
workingDir="templateWork"

mkdir -p ${workingDir}

bundle="$1"
templateProperties="$2"
fullTemplateFile=`mktemp -p ${workingDir} -t fullTemplate.XXXXXXXXXX.properties`
propertiesListFile=`mktemp -p ${workingDir} -t propertiesList.XXXXXXXXXX.properties`
reducedTemplateFile=`mktemp -p ${workingDir} -t reducedTemplate.XXXXXXXXXX.properties`

#templatize the bundle
GatewayMigrationUtility.sh template -b ${bundle} -t ${fullTemplateFile}

#find the list of template properties to leave from the given template properties file
awk '/^[:blank:]*[^#].*=.*$/ {print substr($0, 0, index($0, "=")-1)}' ${templateProperties} > ${propertiesListFile}

# remove all the template properties from the full template properties file
grep -v -F -f ${propertiesListFile} ${fullTemplateFile} > ${reducedTemplateFile}

#partially detemplatize the bundle
GatewayMigrationUtility.sh detemplate -b ${bundle} -t ${reducedTemplateFile}
