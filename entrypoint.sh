#!/bin/sh

set -e

# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$KUBE_CONFIG_DATA" | base64 --decode > /tmp/config
export KUBECONFIG=/tmp/config
kubectl config current-context
echo YAML_FILE=${YAML_FILE}
grep -i image: ${YAML_FILE}
echo BUILD_NUMBER_PREFIX=${BUILD_NUMBER_PREFIX}
echo BUILD_NUMBER=${BUILD_NUMBER}
DOCKER_IMAGE=$(grep image: ${YAML_FILE} | awk -F: '{printf("%s\n",$2)}' | awk '{print $1}')
DOCKER_IMAGE_SLASH=$(echo ${DOCKER_IMAGE} | sed 's#/#\\/#g')
echo DOCKER_IMAGE_SLASH=${DOCKER_IMAGE_SLASH}
sed -E "s/image: .+$/image: ${DOCKER_IMAGE_SLASH}:${TAG}/" ${YAML_FILE} > ${YAML_FILE}.tmp
mv ${YAML_FILE}.tmp ${YAML_FILE}
grep -i image: ${YAML_FILE}
cat .git/config
git log -3
git add -A
git diff --cached
git commit -m "Pods Sirius Settings "${TAG}
git push
