# Terraform-Scripts
New Terraform sample codes are there

Here, there are some Demo examples of real time terraform scripts for different AWS resources and will be keep on updating
as per the things come in work execution.

The backend of the terraform has been stored in the S3 Bucket. As of now the bucket is kept Public.

Run <terraform init> to initialize the backend and to download the necessary plugins for terraform.

Run <terraform fmt> to check the formatables tf files.

Run <terraform validate> to check the validation of the tf files regarding the syntax

Run <terraform plan> to check the plan of terraform what resources it going to create.

Run <terraform apply --auto-approve> to apply the code for creating the resource.

Run <terraform destroy --auto-approve> to delete the entire configuration/infrastructure created by the current code of terraform.