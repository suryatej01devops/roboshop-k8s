#!/bin/bash

# Variables
CLUSTER_NAME="roboshop-dev"
REGION="us-east-1"
NODEGROUP_NAME="roboshop-dev"
INSTANCE_TYPE="t3.micro"
DESIRED_CAPACITY=6

echo "Creating EKS cluster configuration file..."

cat <<EOF > cluster.yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: ${CLUSTER_NAME}
  region: ${REGION}

managedNodeGroups:
  - name: ${NODEGROUP_NAME}
    instanceTypes: ["${INSTANCE_TYPE}"]
    desiredCapacity: ${DESIRED_CAPACITY}
    spot: true
EOF

echo "Cluster config file created."

echo "Creating EKS Cluster..."

eksctl create cluster -f cluster.yaml

echo "Updating kubeconfig..."

aws eks update-kubeconfig --region ${REGION} --name ${CLUSTER_NAME}

echo "Verifying nodes..."

kubectl get nodes

echo "EKS Cluster setup completed!"