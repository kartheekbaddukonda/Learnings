#!/usr/bin/env bash
set -ex

usage () {
    echo "Usage: $0 deployment region cluster-name micro-service image-id"
    echo "       deployment = (production | vpcproduction | staging | prestaging | sor | gate | preproduction)"
    echo "       region = (us-south | eu-gb | au-syd | eu-de | ap-north | us-east)"
    echo "       cluster-name = the name of the kubernetes cluster"
    echo "       micro-service = (iam-uum)"
    echo "       image-id = the image tag id to update"
    echo "       build-number = the release number"
    echo "       icr-namespace = Registry Namespace to retrieve the digest"
    echo "       deploy usershelper = Deploy Users Helper Microservice "
}

function get_kube_dir () {
    PATHSTRING="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    suffix=/
    PATHSTRING=${PATHSTRING%$suffix}

    suffix=/scripts
    PATHSTRING=${PATHSTRING%$suffix}
    echo ${PATHSTRING}
}

KUBE_DIR=$(get_kube_dir)

if [ "$#" -lt 5 ]; then
    echo "Illegal number of parameters"
    usage
    exit 1
fi

DEPLOYMENT=$1          # production or vpcproduction or staging or prestaging or sor or gate or preproduction
REGION=$2              # region deploying to (us-south, eu-gb, eu-de, au-syd, eu-de, ap-north, us-east)
CLUSTER=$3             # cluster name
MICRO_SERVICE=$4       # iam-uum
IMAGE_ID=$5            # the tag ID
BUILD_NUMBER=$6        # Current Build Number
ICR_NAMESPACE=$7       # Container Registry Name Space
DEPLOY_UH_SERVICE=$8   # Deploy UsersHelper Service
ADD_ANNOTATION=$9      # boolean flag to add Annotations 

if [ "${DEPLOYMENT}" != "production" -a "${DEPLOYMENT}" != "vpcproduction" -a "${DEPLOYMENT}" != "staging" -a "${DEPLOYMENT}" != "prestaging" -a "${DEPLOYMENT}" != "sor" -a "${DEPLOYMENT}" != "gate" -a "${DEPLOYMENT}" != "dev" -a "${DEPLOYMENT}" != "preproduction" -a "${DEPLOYMENT}" != "vpcstaging" ]; then
    echo "deployment value must be production or vpcproduction or staging or prestaging or sor or gate or preproduction or dev"
    usage
    exit 1
fi

echo $REPO
echo $VERSION_ENDPOINT

COMMIT_OUTPUT=$(curl -H "env: test" $VERSION_ENDPOINT/version  -u $VERSION_USER:$VERSION_PASS)
CONFIG_COMMIT=$(echo $COMMIT_OUTPUT | jq -r '.gitCommitSHA' | cut -d ':' -f 2)

DEPLOYMENT_NAME=${MICRO_SERVICE}
if [ "${MICRO_SERVICE}" == "iam-uum" ]; then
    # Remove trailing whitespaces from IMAGE_ID
    IMAGE_ID="$(echo ${IMAGE_ID} | sed -e 's/[[:space:]]*$//')"
    # Fetching image digests for all micro services with image id => ${IMAGE_ID}
    IMAGE_DIGESTS=`ibmcloud cr image-digests --restrict $ICR_NAMESPACE --format "{{ .Repository }} {{.Digest}} {{ .Tags }}" | grep "\(\[\|\s\)$IMAGE_ID\(\]\|\s\)"`

    echo "IMAGE_DIGESTS" :: "$IMAGE_DIGESTS"

    AG_DIGEST=`echo "$IMAGE_DIGESTS" | grep 'iam-uum-accessgroups-rh' | awk '{ print $2 }'`
    USERS_DIGEST=`echo "$IMAGE_DIGESTS" | grep 'iam-uum-users-rh' | awk '{ print $2 }'`
    UH_DIGEST=`echo "$IMAGE_DIGESTS" | grep 'iam-uum-usershelper-rh' | awk '{ print $2 }'`
    CL_DIGEST=`echo "$IMAGE_DIGESTS" | grep 'iam-uum-changelistener-rh' | awk '{ print $2 }'`
    REDIS_DIGEST=`echo "$IMAGE_DIGESTS" | grep 'iam-uum-redis-rh' | awk '{ print $2 }'`
    STUNNEL_DIGEST=`echo "$IMAGE_DIGESTS" | grep 'iam-uum-stunnel-rh' | awk '{ print $2 }'`

    echo "AG_DIGEST:: "    $AG_DIGEST
    echo "USERS_DIGEST::"  $USERS_DIGEST
    echo "UH_DIGEST:: "    $UH_DIGEST
    echo "CL_DIGEST:: "    $CL_DIGEST
    echo "REDIS_DIGEST::"  $REDIS_DIGEST
    echo "STUNNEL_DIGEST:" $STUNNEL_DIGEST

    if [[ -z $AG_DIGEST ]] || [[ -z $USERS_DIGEST ]] || [[ -z $UH_DIGEST ]] || [[ -z $CL_DIGEST ]] || [[ -z $REDIS_DIGEST ]] || [[ -z $STUNNEL_DIGEST ]]; then
        echo "Image digests are empty, some issue with fetching the digests from ICR"
        exit 1
    fi

    SET_IMAGE_NUMBER="image.number=${IMAGE_ID}"
    SET_UUM_VERSION="access_groups.ImageVersion=@${AG_DIGEST}"
    SET_CL_VERSION="change_listener.image_version=@${CL_DIGEST}"
    SET_UUM_USERS_VERSION="users.image_version=@${USERS_DIGEST}"
    SET_UUM_USERS_HELPER_VERSION="users_helper.image_version=@${UH_DIGEST}"
    SET_REDIS_VERSION="redis.ImageVersion=@${REDIS_DIGEST}"
    SET_STUNNEL_VERSION="stunnel.ImageVersion=@${STUNNEL_DIGEST}"

    # Now using image id, if it comes as a mandatory req
#    SET_UUM_VERSION="access_groups.ImageVersion=:${IMAGE_ID}"
#    SET_CL_VERSION="change_listener.image_version=:${IMAGE_ID}"
#    SET_UUM_USERS_VERSION="users.image_version=:${IMAGE_ID}"
#    SET_UUM_USERS_HELPER_VERSION="users_helper.image_version=:${IMAGE_ID}"
#    SET_REDIS_VERSION="redis.ImageVersion=:${IMAGE_ID}"
#    SET_STUNNEL_VERSION="stunnel.ImageVersion=:${IMAGE_ID}"
    #Set Build number, if build-number is empty it will update the old release
    [ -z "$BUILD_NUMBER" ] && SET_BUILD_NUMBER="build.number=${BUILD_NUMBER}" || SET_BUILD_NUMBER="build.number=-${BUILD_NUMBER}"
    KUBE_NAMESPACE="default"
else
    echo "the micro-service must be iam-uum"
    usage
    exit 1
fi

HELM_DIR=${KUBE_DIR}/charts/${MICRO_SERVICE}-helm

if [ ! -d ${HELM_DIR} ]; then
    echo "Can not find the helm directory ${HELM_DIR}"
    exit 1
fi

# Default to 120 times of waiting for the deployment
max_count=120
# But let us try to have a better way of doint it with some simple math of
# count of current instances times a known multiplier per deployment.
if [ "${build_out_multiplier}" != "" ]; then
    kubectl describe deployment ${MICRO_SERVICE} > /dev/null
    if [ $? = 0 ]; then
        current_count=`kubectl describe deployment ${MICRO_SERVICE} | grep "Replicas:" | cut -f 2 -d'|' | awk '{print $1}'`
        if [ ${current_count} -gt 0 ]; then
            let max_count=${current_count}*${build_out_multiplier}
        fi
    fi
fi

ENVIRONMENT_VALUES_FILE=${KUBE_DIR}/deployment-values/${DEPLOYMENT}/${DEPLOYMENT}.yaml

if [ ! -f ${ENVIRONMENT_VALUES_FILE} ]; then
    echo "Can not find the environment values file ${ENVIRONMENT_VALUES_FILE}"
    exit 1
fi

CLUSTER_VALUES_FILE=${KUBE_DIR}/deployment-values/${DEPLOYMENT}/${REGION}/${CLUSTER}.yaml

if [ ! -f ${CLUSTER_VALUES_FILE} ]; then
    echo "Can not find the cluster values file ${CLUSTER_VALUES_FILE}"
    exit 1
fi

PARAMS="--reset-values"

if [[ $ADD_ANNOTATION == "true" ]]; then
    SET_CONFIG_REPO="annotations.configrepo=${REPO}"
    SET_CONFIG_COMMIT="annotations.configcommit=${CONFIG_COMMIT}"
    PARAMS= "${PARAMS} --set ${SET_CONFIG_REPO} --set ${SET_CONFIG_COMMIT}"       
fi

if [ ${MICRO_SERVICE} == "iam-uum" ]; then
  PARAMS="${PARAMS} --set ${SET_IMAGE_NUMBER} --set ${SET_UUM_VERSION} --set ${SET_CL_VERSION} --set ${SET_UUM_USERS_VERSION} --set ${SET_UUM_USERS_HELPER_VERSION} --set ${SET_REDIS_VERSION} --set ${SET_STUNNEL_VERSION} --set ${SET_BUILD_NUMBER} "
  
  #Flag to deploy UH Service, Black will be false & True only for one cluster/environment - see rollout_groups.sh
  PARAMS="${PARAMS} --set users_helper.enabled=$DEPLOY_UH_SERVICE "
fi

if [[ ! -z "$REGISTRY_NAMESPACE" ]]; then
    PARAMS="${PARAMS} --set RegistryNamespace=${REGISTRY_NAMESPACE}"
fi

# Update the Micro service chart version with Image version
sed -i -e "s/^appVersion:.*/appVersion: \"${BUILD_NUMBER}\"/" ${HELM_DIR}/Chart.yaml

#determine the helm release name, avoid "-" if build_number is empty
[ -z "$BUILD_NUMBER" ] && HELM_RELEASE_NAME="${MICRO_SERVICE}" || HELM_RELEASE_NAME="${MICRO_SERVICE}-$BUILD_NUMBER"
helm upgrade -i $HELM_RELEASE_NAME ${HELM_DIR} -f ${ENVIRONMENT_VALUES_FILE} -f ${CLUSTER_VALUES_FILE} ${PARAMS}

if [ $? != 0 ]; then
    echo helm upgrade failed. Check error above.
    exit 1
fi

print_pod_states() {
    while true; do
        echo "Deployment in progress..."
        helm status $HELM_RELEASE_NAME
        echo "-------------------------------------------------------------------------------------------"
        sleep 10
    done
}

# Print the pod states in the background
print_pod_states &
print_pid=$!
trap 'kill $print_pid >/dev/null 2>&1' EXIT

echo "Now checking that all deployments are finished in namespace: ${KUBE_NAMESPACE}"

for deployment in $(kubectl get deployments --namespace ${KUBE_NAMESPACE} --output jsonpath='{.items[*].metadata.name}'); do
    # Here we are assuming that the deployments have the same substring as the release
    if [[ ${deployment} == ${MICRO_SERVICE}*${BUILD_NUMBER} ]]; then
        echo "Checking deployment: ${deployment}..."
        kubectl rollout status deployment ${deployment}
    fi
done