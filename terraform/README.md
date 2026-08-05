# Terraform Infrastructure

## Overview

This directory contains the Infrastructure-as-Code (IaC) implementation for the Azure environment using Terraform.

The goal of this project is to provision a production-inspired Azure environment that demonstrates common cloud architecture patterns including high availability, secure administration, reusable infrastructure, and automated virtual machine provisioning.

Terraform is responsible only for provisioning infrastructure. Operating system configuration and application deployment are delegated to Puppet to maintain a clear separation of responsibilities.

---

# Infrastructure Overview

Terraform provisions the following Azure resources:

- Resource Group
- Virtual Network (VNet)
- Application Subnet
- Azure Bastion Subnet
- Azure Application Gateway Subnet
- Azure Private DNS Zone
- Virtual Network Link
- Network Security Groups (NSGs)
- Network Security Rules
- Network Interfaces (NICs)
- Linux Virtual Machines
- Azure Bastion
- Azure Application Gateway
- System Assigned Managed Identities

The resulting architecture provides a secure, highly available environment that can be expanded by modifying Terraform variables instead of changing infrastructure code.

---

# Project Structure

```text
terraform/
├── appgateway.tf
├── bastion.tf
├── compute.tf
├── dns.tf
├── locals.naming.tf
├── locals.tf
├── network.tf
├── nsg.tf
├── providers.tf
├── resourcegroup.tf
├── terraform.tfvars
├── variables.tf
├── versions.tf
│
├── cloud_init/
│   ├── bootstrap-puppet.sh.tftpl
│   └── cloud-init.yaml.tftpl
│
└── README.md
```

Each Terraform file is organized by resource type to improve readability and simplify maintenance.

---

# Design Principles

## Infrastructure as Code

All Azure resources are deployed declaratively using Terraform.

Benefits include:

- Version-controlled infrastructure
- Repeatable deployments
- Environment consistency
- Easier disaster recovery
- Code reviews through Git

---

## Separation of Responsibilities

Infrastructure provisioning and server configuration are intentionally separated.

### Terraform responsibilities

- Azure resource provisioning
- Virtual networking
- Security
- Identity
- Virtual machines
- Initial VM bootstrapping

### Puppet responsibilities

- Software installation
- Docker installation
- NGINX deployment
- Configuration management
- Future application deployments

This separation follows common enterprise Infrastructure-as-Code practices.

---

# Naming Convention

Resource names are generated from centralized Terraform locals to ensure consistency.

Format:

```text
<project>-<environment>-<resource>
```

Examples:

```text
nginx-dev-rg
nginx-dev-vnet
nginx-dev-vm01
nginx-dev-appgw
```

Centralizing naming conventions reduces duplicated code and simplifies future changes.

---

# Virtual Machine Configuration

Virtual machines are defined using a Terraform map.

Example:

```hcl
vms = {

  puppet = {
    zone = 1
    role = "puppet"
  }

  vm01 = {
    zone = 1
    role = "app"
  }

  vm02 = {
    zone = 2
    role = "app"
  }

  vm03 = {
    zone = 3
    role = "app"
  }

}
```

Terraform uses `for_each` to automatically provision:

- Network Interfaces
- Linux Virtual Machines
- Availability Zone placement
- Managed Identities
- Cloud-init configuration

Scaling the environment only requires adding another VM definition to the map.

---

# High Availability

Application servers are distributed across multiple Azure Availability Zones.

Benefits include:

- Higher availability
- Fault tolerance
- Protection against datacenter failures
- Improved resiliency

Azure Application Gateway distributes traffic across all application servers.

---

# Networking

The infrastructure uses a single Virtual Network containing dedicated subnets for:

- Application Virtual Machines
- Azure Bastion
- Azure Application Gateway

Application servers are deployed without public IP addresses and communicate over private networking.

---

# Network Security

Network Security Groups follow the principle of least privilege.

Rules allow only the traffic required for:

- HTTPS to the Application Gateway
- Azure Bastion administrative access
- Puppet Server communication
- Internal application traffic

Administrative access is performed exclusively through Azure Bastion, eliminating the need to expose SSH to the public Internet.

---

# Private DNS

A Private DNS Zone provides internal name resolution for the environment.

Example:

```text
puppet.puppet.internal
```

Using private DNS avoids hardcoded IP addresses and simplifies infrastructure changes.

---

# Cloud-init Bootstrapping

Each virtual machine receives a cloud-init configuration during provisioning.

Cloud-init performs only the initial bootstrap tasks:

- Configure the hostname
- Copy the bootstrap script
- Execute the bootstrap script

The bootstrap script determines the VM role and installs either:

- Puppet Server
- Puppet Agent

This keeps the cloud-init configuration lightweight while delegating installation logic to a dedicated bootstrap script.

---

# Managed Identity

Each virtual machine is configured with a System Assigned Managed Identity.

Benefits include:

- No stored credentials
- Azure-native authentication
- Improved security
- Easier integration with Azure services such as Key Vault

---

# Azure Application Gateway

Azure Application Gateway acts as the public entry point for the application.

Current capabilities include:

- Layer 7 load balancing
- Backend pools
- Health probes
- HTTP routing

Future enhancements could include:

- HTTPS termination
- Web Application Firewall (WAF)
- Path-based routing
- URL rewrite rules

---

# Azure Bastion

Administrative access is provided through Azure Bastion.

Advantages include:

- No public SSH access
- Browser-based SSH sessions
- Reduced attack surface
- Secure remote administration

---

# Deployment Workflow

Authenticate with Azure.

Initialize Terraform:

```bash
terraform init
```

Validate the configuration:

```bash
terraform validate
```

Review the execution plan:

```bash
terraform plan
```

Deploy the infrastructure:

```bash
terraform apply
```

Terraform provisions the Azure infrastructure and cloud-init bootstraps each virtual machine.

---

# Future Improvements

Potential enhancements include:

- Azure Key Vault integration
- Web Application Firewall (WAF)
- Terraform remote state with Azure Storage
- GitHub Actions CI/CD pipeline
- Azure Monitor and Log Analytics
- Azure Verified Modules (AVM)
- Multiple deployment environments (Development, Test, Production)
- Virtual Machine Scale Sets
- Azure Firewall
- Azure Front Door

---

# Learning Objectives

This project demonstrates practical experience with:

- Terraform
- Microsoft Azure
- Infrastructure as Code
- Azure Virtual Networking
- Azure Application Gateway
- Azure Bastion
- Azure Private DNS
- Availability Zones
- Cloud-init
- Managed Identities
- Reusable Terraform design patterns
- Enterprise infrastructure organization
- Integration with Puppet for configuration management