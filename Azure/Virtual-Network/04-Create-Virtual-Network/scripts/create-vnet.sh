#!/bin/bash

# Create Azure Virtual Network

az network vnet create \
  --resource-group <RESOURCE_GROUP_NAME> \
  --name devops-vnet \
  --location westus \
  --address-prefix 10.0.0.0/16