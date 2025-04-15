#!/bin/bash
export MSYS_NO_PATHCONV=1

SUBSCRIPTION_ID="4aacf319-cc4f-4aa3-a3f8-71d4c1e63bdb"

# Change to microservices directory and exit if it fails

cd terraform/microservices || exit

# Initialize terraform in microservices
terraform init

# Apply terraform for microservices
terraform apply -var="subscription_id=$SUBSCRIPTION_ID" 

# Get and save outputs from terraform
ACR_NAME=$(terraform output -raw acr_name)
ACR_LOGIN_SERVER=$(terraform output -raw acr_login_server)
RESOURCE_GROUP_NAME=$(terraform output -raw resource_group_name)
CONTAINER_APP_ENVIRONMENT_ID=$(terraform output -raw container_app_environment_id)
IDENTITY_ID=$(terraform output -raw identity_id)

if [ -z "$ACR_NAME" ] || [ -z "$ACR_LOGIN_SERVER" ]; then
  echo "Error: Some Terraform outputs are empty!"
  exit 1
fi


echo "ACR_NAME: $ACR_NAME"
echo "ACR_LOGIN_SERVER: $ACR_LOGIN_SERVER"
echo "RESOURCE_GROUP_NAME: $RESOURCE_GROUP_NAME"
echo "CONTAINER_APP_ENVIRONMENT_ID: $CONTAINER_APP_ENVIRONMENT_ID"
echo "IDENTITY_ID: $IDENTITY_ID"

# Pull the required Docker images
docker pull redis:7.2-alpine
docker pull openzipkin/zipkin:latest
docker pull nginx:latest

# Azure login for ACR
az acr login --name "$ACR_NAME"

# Tag the images for ACR
docker tag nginx:latest "$ACR_LOGIN_SERVER/nginx:latest"
docker tag openzipkin/zipkin:latest "$ACR_LOGIN_SERVER/zipkin:latest"
docker tag redis:7.2-alpine "$ACR_LOGIN_SERVER/redis:7.2-alpine"

# Push the images to ACR
docker push "$ACR_LOGIN_SERVER/nginx:latest"
docker push "$ACR_LOGIN_SERVER/zipkin:latest"
docker push "$ACR_LOGIN_SERVER/redis:7.2-alpine"

# Return to the previous directory and exit if it fails
cd ../container_apps || exit

# Initialize terraform in container_apps
terraform init

# Apply terraform for container_apps
terraform apply -var="subscription_id=$SUBSCRIPTION_ID" -var="acr_login_server=$ACR_LOGIN_SERVER" -var="resource_group_name=$RESOURCE_GROUP_NAME" -var="container_app_environment_id=$CONTAINER_APP_ENVIRONMENT_ID" -var="identity_id=$IDENTITY_ID" -auto-approve