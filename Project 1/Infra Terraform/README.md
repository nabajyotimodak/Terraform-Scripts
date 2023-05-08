# This is the terraform script for creating the Advisory Chat-Bot (Rasa)

## Data Sources used for this terraform configuration are:
    The newly created VPC.
    The Subnets and Security Groups under this VPC.
    The AMI of the EC2 instance.

---

## The Terraform Commands to use:
    To check & validate the code: [ terraform validate ]
    To initialize the required plugins and backends: [ terraform init ]
    To see the plan that terraform will execute while applying the code: [ terraform plan ]
    To apply the configuration/code: [ terraform apply ]
                                     [ terraform apply --auto-approve]

---

## The Resources to be created: (7 resources)
    * Prod - EC2 instance for the chatbot. [1 nos.]
    * An application load balancer with HTTPS listener with fixed return of 404. [2 nos.]
    * Two listener rules (Path based routing / forward action). [2 nos.]
    * one Target Group with registed target (ChatBot-Prod-EC2). [2 nos.]