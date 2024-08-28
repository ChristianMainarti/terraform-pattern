# terraform-pattern

**Terraform Configuration for AWS ECS Cluster**

This project contains Terraform configuration files to set up an AWS ECS Cluster with Fargate as the capacity provider, along with auto-scaling, task definitions, network configuration, ECS service, load balancer, and necessary IAM roles and policies.

## Prerequisites

- **Terraform v1.0 or later**
- **AWS CLI** configured with appropriate credentials
- An **AWS account** with permissions to create ECS resources, IAM roles, policies, VPCs, and Load Balancers

## Directory Structure
.
├── main.tf
├── provider.tf
├── network.tf
├── task_definition.tf
├── ecs_service.tf
├── ecs_cluster.tf
├── role-policy.tf
├── alb.tf
└── README.md


## How to Use

1. **Initialize Terraform**: Run the following command to initialize the Terraform environment.
   terraform init

2. **Plan the Deployment**: Generate an execution plan.
    terraform plan

3.**Apply the Configuration**: Create the resources in AWS.
    terraform apply

4.**Destroy the Resources**: When you no longer need the resources, you can destroy them using:
terraform destroy

## Notes
Ensure that you have the necessary IAM permissions to create and manage ECS, IAM roles, policies, VPCs, and Load Balancers.
Adjust the scaling policies and capacity provider settings based on your specific use case and expected load.

## License
This project is licensed under the MIT License - see the LICENSE file for details.