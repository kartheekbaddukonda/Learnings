#!/bin/bash
set -ex
# Login to IBM Cloud and install cs plugin
tar -xf /opt/bluemix-cli-plugins.tgz -C /home/jenkins
ibmcloud login -a https://cloud.ibm.com --no-region --apikey $BM_API_KEY
ibmcloud ks init
ibmcloud cr login
ibmcloud cr region-set us-south

# CONFIGURE KUBECTL
ibmcloud ks cluster config --cluster $CLUSTER_NAME

# Deploy Microservice
cd src/github.ibm.com/IAM/uum/deployments/helm

# Required:  $ENVIRONMENT $REGION $CLUSTER_NAME $MICRO_SERVICE $IMAGE_VERSION
echo "Using the following parameters: "
echo "ENVIRONMENT: $ENVIRONMENT"
echo "REGION: $REGION"
echo "CLUSTER_NAME: $CLUSTER_NAME"
echo "MICRO_SERVICE: $MICRO_SERVICE"
echo "IMAGE_VERSION: $IMAGE_VERSION"
echo "BUILD_NUMBER: $BUILD_NUMBER"
echo "ICR_NAMESPACE: $ICR_NAMESPACE"

#check for UUM clusters  (for dev - && "$CLUSTER_NAME" != *"dev"*)
if [[  "$CLUSTER_NAME" == "iam-am-dev-us-south-dal12" ]]; then
  # deploy users helper on dev
  ./upgrade.sh $ENVIRONMENT $REGION $CLUSTER_NAME $MICRO_SERVICE "$IMAGE_VERSION" "$BUILD_NUMBER" $ICR_NAMESPACE true false

elif [[ "$CLUSTER_NAME" == "iam-uum"* ]] && [[ "$CLUSTER_NAME" != *"-preprod-"* ]]; then

  #determine the current uum deployment version
  PREV_BUILD_NUMBER=$(helm list -f iam-uum --deployed --date -r -o json | jq '.[0].app_version' | tr -d '"')

  #first deploy Virtual services as it would take sometime to propagate changes to the mesh
  ./deploy_black_vs.sh "$ENVIRONMENT" "$PREV_BUILD_NUMBER" "$BUILD_NUMBER" "$REGION" "$CLUSTER_NAME"

  #deploy micro-services after the above, by the time microservices come up assuming istio mesh would be in sync
  ./upgrade.sh $ENVIRONMENT $REGION $CLUSTER_NAME $MICRO_SERVICE "$IMAGE_VERSION" "$BUILD_NUMBER" $ICR_NAMESPACE false true

  #checking if istio config's are propagated to the newly created pods in the new deployment
  ../Jenkins/Bash_Scripts/validate_istio_mesh.sh "$BUILD_NUMBER"

else

  #no istio stuff for AM clusters, BUILD_NUMBER="" so it always upgrades the default
  ./upgrade.sh $ENVIRONMENT $REGION $CLUSTER_NAME $MICRO_SERVICE $IMAGE_VERSION "" $ICR_NAMESPACE false false

fi
