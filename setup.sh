#!/bin/bash
#################
# This script will setup this project
# run ./setup.sh command. To setup this project
#################

function install_package() {
    local package_name=${1}
    if ! apt-get install -y ${package_name}
    then
        echo -e "\033[0:31 ${package_name} not able to install"
        exit 1
    fi
}

function maven_target(){
    local maven_cmd=${1}
    if ! mvn ${1}
    then
        echo -e "\033[0:31 ${maven_cmd} fail"
        exit 1
    fi
}

if [[ ${UID} != 0 ]]
then
    echo -e "\033[0;31m User is not root user"
    exit 1
fi

##############################
# Variables
##############################
read -p "Please enter access path : " APP_CONTEXT
APP_CONTEXT=${APP_CONTEXT:-app}

if ! apt-get update
then
    echo -e "\033[0:31] not able to run apt-get update"
    exit 1
fi

install_package maven
install_package tomcat9
maven_target test
maven_target package


# \033[0;31m  - fail message
# \033[0;32m  - success message
# \033[0;33m  - warning message

# cp -rvf target/hello-world-0.0.1-SNAPSHOT.war /var/lib/tomcat9/webapps/app.war
# if [[ $? != 0 ]]
if cp -rvf target/hello-world-0.0.1-SNAPSHOT.war /var/lib/tomcat9/webapps/${APP_CONTEXT}.war
then
    echo -e "\033[0;32m Application Deployed Successfully. You can access it using http://{IPADDRESS}/${APP_CONTEXT}"
else
    echo -e "\033[0;31m Application failed to deploy"
    exit 1
fi

exit 0