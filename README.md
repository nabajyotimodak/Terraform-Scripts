# Terraform-Scripts

## New Terraform sample codes are there

Here, there are some Demo examples of real time terraform scripts for different AWS resources and will be keep on updating as per the things come in work execution.

The backend of the terraform has been stored in the S3 Bucket. As of now the bucket is kept Public.

Run [terraform init] to initialize the backend and to download the necessary plugins for terraform.

Run [terraform fmt] to check the formatables tf files.

Run [terraform validate] to check the validation of the tf files regarding the syntax

Run [terraform plan] to check the plan of terraform what resources it going to create.

Run [terraform apply --auto-approve] to apply the code for creating the resource.

Run [terraform destroy --auto-approve] to delete the entire configuration/infrastructure created by the current code of terraform.

Sometimes, configuring the AWS credentials also not initialize the backend. At that time, we can rin the init command in the bellow format:
[ terraform init -backend-config="access_key=<your access key>" -backend-config="secret_key=<your secret key>" ]

# Some extra concepts:
## Concept -1
Sometimes with some basic provider block configuration the terraform scripts may not work showing an error such as:
### Error: error configuring Terraform AWS Provider: no valid credential sources for Terraform AWS Provider found.
### Error: NoCredentialProviders: no valid providers in chain
caused by: EnvAccessKeyNotFound: failed to find credentials in the environment.
SharedCredsLoad: failed to load profile, optumresearchprod-tf.
EC2RoleRequestError: no EC2 instance role found
caused by: RequestError: send request failed
  on main.tf line 12, in provider "aws":
  12: provider "aws" {...
### At that time we have to provide the cloud provider's credentials in the provider block and we can proceed like such as shown below:
provider "cloud-name" {
  profile = "any default name"
  region  = "region in the cloud"
  access_key = "<your-access-key>"
  secret_key = "<your-secret-key"
  # Controlling version to help ensure consistence and only apply tested versions.
  version = "~> 3.0"
}
