#!/usr/bin/env bash

#
# Script for templating the jinja2 app-config.local.yaml file.
#
# It collectes all the parameters passed with the - switch into jinja2 
#  key/value variables that are to be replaced inside the jinja2 template.

set -o errexit

show_usage () {
    echo ""
    echo >&2 "$@"
    echo ""
    echo "Script for templating the jinja2 app-config.yaml file."
    echo ""
    echo "For required parameters check the jinja2 template file being used."
    echo "The default template file is located at the ./manifest/app-config.local.yaml.j2" file.
    echo ""
    echo "Optional parameters:"
    echo ""
    echo -e "--template_file <value>\t\tCustom location for the template file"
    echo -e "--help\t\t\t\tShow this message"
    echo ""
    exit 1
}

JINJA2_TEMPLATE_FILE="./manifest/app-config.local.yaml.j2"
JINJA2_TEMPLATE_VARIABLES=""
INVALID_SWITCH=""

set +e
while [ $# -gt 0 ]; do
    # echo "$1"
    if [[ $1 == "--"* ]]; then
        case $1 in
            --help) show_usage; break 2 ;;
            --template_file) JINJA2_TEMPLATE_FILE="${2}"; shift; shift ;; 
            *) show_usage "Invalid switch $1" ; break 2 ;;
        esac
    elif [[ $1 == "-"* ]]; then
        param="${1/-/}";
        shift;
        value="${1}";
        echo "param: ${param}, value: ${value}"
        shift;
        JINJA2_TEMPLATE_VARIABLES+=" -D${param}=${value}"
    fi
done
set -e

echo " "

echo "Template file location: ${JINJA2_TEMPLATE_FILE}"
echo "Templating app-config with the following parameters: "
echo "  ${JINJA2_TEMPLATE_VARIABLES}"

echo "Starting the template process..."

#echo "jinja2 ${JINJA2_TEMPLATE_VARIABLES} ${JINJA2_TEMPLATE_FILE} > app-config.local.yaml"
#jinja2 ${JINJA2_TEMPLATE_VARIABLES} ./manifest/app-config.local.yaml.j2
jinja2 ${JINJA2_TEMPLATE_VARIABLES} ${JINJA2_TEMPLATE_FILE} --strict > app-config.local.yaml

echo "Template process finished!"
