# Enterprise NGINX Platform on Azure

## Overview

This project demonstrates how to provision and configure a highly available web platform on Microsoft Azure using **Terraform** for Infrastructure-as-Code and **Puppet** for configuration management.

The environment provisions multiple Linux virtual machines across Availability Zones behind an Azure Application Gateway. After the infrastructure is deployed, Puppet automatically configures the application servers by installing Docker and deploying an NGINX container.

The project follows common enterprise practices including reusable Infrastructure-as-Code, configuration management, private networking, managed identities, and centralized ingress.

---

## Architecture

```
                 Internet
                      │
                      ▼
          Azure Application Gateway
                      │
          ┌───────────┼───────────┐
          │           │           │
       VM01        VM02       VM03
      Zone 1      Zone 2      Zone 3
          │           │           │
          └───────────┼───────────┘
                      │
                Virtual Network

                      │
                Puppet Server

                      │
               Azure Bastion
```

---

## Technologies

| Technology | Purpose |
|------------|---------|
| Terraform | Provision Azure infrastructure |
| Puppet | Configuration management |
| Azure Application Gateway | Layer 7 load balancing and reverse proxy |
| Azure Bastion | Secure administrative access |
| Docker | Container runtime |
| NGINX | Web server |
| Ubuntu Server 24.04 LTS | Operating system |
| Private DNS Zone | Internal name resolution |
| Managed Identity | Azure authentication without secrets |

---

## Design Goals

### High Availability

- Multiple Availability Zones
- Stateless application servers
- Layer 7 traffic distribution

### Infrastructure as Code

- Declarative infrastructure
- Reusable Terraform modules
- Version-controlled deployments

### Configuration Management

- Automated software installation
- Consistent server configuration
- Idempotent deployments

### Security

- Private networking
- Azure Bastion
- Network Security Groups
- Managed Identities

### Scalability

Application servers can be added by updating the Terraform VM map without changing the infrastructure code.

---

## Repository Structure

```
terraform/
    Infrastructure provisioning

puppet/
    Configuration management

README.md
    Project overview
```

---

## Documentation

Detailed implementation guides are available in:

- `terraform/README.md`
- `puppet/README.md`