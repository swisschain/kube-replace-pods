#!/bin/sh

set -e

# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$KUBE_CONFIG_DATA" | base64 --decode > /tmp/config
export KUBECONFIG=/tmp/config
kubectl config current-context
echo YAML_FILE=${INPUT_YAML_FILE}
echo BUILD_NUMBER_PREFIX=${BUILD_NUMBER_PREFIX}
echo BUILD_NUMBER=${BUILD_NUMBER}
