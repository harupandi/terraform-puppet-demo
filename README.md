# Azure Highly Available Nginx Platform (Terraform + Puppet)

## Overview

This project demonstrates the design and deployment of a highly available Nginx application platform on Microsoft Azure using Infrastructure as Code (IaC) and configuration management.

The goal is to build a production-inspired Azure environment where:

- Infrastructure is provisioned using Terraform.
- Virtual machines are distributed across Azure Availability Zones.
- Secure administrative access is provided through Azure Bastion.
- Application traffic is distributed using Azure Application Gateway.
- VM configuration is automated using Puppet.
- Nginx runs inside Docker containers on Linux virtual machines.

The architecture follows Azure best practices around networking isolation, security, availability, and identity management.

---

# Architecture

## Target Architecture
                     Internet
                        |
                        |
                Azure Application Gateway
                        |
                        |
          ---------------------------------
          |              |                |
        VM01            VM02             VM03
      Zone 1          Zone 2           Zone 3
          |              |                |
          ---------------------------------
                        |
                Workload Subnet

                        ^
                        |
                Azure Bastion
                        |
                Administrator Access

---

# Azure Resources

The final solution will contain:

## Networking

- Resource Group
- Virtual Network
- Dedicated subnets:
  - AzureBastionSubnet
  - Application Gateway subnet
  - Workload subnet
- Network Security Group
- NSG rules and subnet association

## Compute

- Three Linux Virtual Machines
- Deployment across Availability Zones:
  - VM01 → Zone 1
  - VM02 → Zone 2
  - VM03 → Zone 3

VM specifications:

- Ubuntu Linux
- Standard_D2ds_v7 VM size
- System Assigned Managed Identity
- SSH key authentication
- No public IP addresses

## Security

- Azure Bastion for secure VM access
- No direct SSH exposure to the Internet
- Network isolation using NSGs
- Managed Identity enabled on virtual machines

## Application Delivery

Planned:

- Azure Application Gateway
- Public frontend endpoint
- Backend pool containing the three Nginx VMs
- HTTP listener
- Health probes
- Routing rules

## Configuration Management

Planned:

- Puppet installation
- Puppet agent configuration
- Docker installation
- Nginx container deployment

---

# Terraform Structure
terraform/

├── provider.tf
├── versions.tf
├── variables.tf
├── terraform.tfvars.example
│
├── locals.tf
├── locals.naming.tf
│
├── main.tf
├── network.tf
├── nsg.tf
├── compute.tf
├── bastion.tf
├── appgateway.tf
│
├── outputs.tf
└── .terraform.lock.hcl

---

# Terraform Design Decisions

## Resource Naming

Resource names are generated using Terraform locals.

Example:
docker-nginx-dev-rg
docker-nginx-dev-vnet
docker-nginx-dev-vm01


Naming is centralized in:
locals.naming.tf


This avoids hardcoding resource names throughout the Terraform code.

---

## VM Deployment Pattern

VMs are modeled using Terraform maps and `for_each`.

Example:

```hcl
vms = {

  vm01 = {
    zone = 1
  }

  vm02 = {
    zone = 2
  }

  vm03 = {
    zone = 3
  }

}