#!/bin/bash

# Create Azure Virtual Network

az network vnet create \
  --resource-group <RESOURCE_GROUP_NAME> \
  --name datacenter-vnet \
  --location eastus \
  --address-prefix 192.168.0.0/24