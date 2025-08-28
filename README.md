## Terraform Azure: RG → VNet → Subnet → PIP → NSG → NIC → Linux VM

### This project provisions a basic Azure infrastructure:

- Resource Group

- Virtual Network + Subnet

- Public IP

- Network Security Group with SSH rule

- Network Interface associated with the NSG and Public IP

- Linux VM (Ubuntu 22.04) with SSH key login
  Additionally: consistent tagging and naming based on locals.

### Requirements

- Azure CLI logged in to the target subscription

- SSH key pair

### Repository Structure

- versions.tf

- provider.tf

- variables.tf

- main.tf

- outputs.tf

### Conventions

- Naming: consistent prefix from locals, style a-z0-9-.

- Tags: shared in locals.common_tags + role per component.

- References: creation order follows resource references (RG → VNet → Subnet → NIC → VM).

### Quick Start

terraform init
terraform plan -out=plan.plan
terraform apply "plan.plan"
