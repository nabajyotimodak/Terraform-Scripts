#############################################################################################################
# Backend Configurations / State Lock as well (if any)
## Backend Code can be uncommented while runnning the terraform code
# Pre-requisite: Has to create a S3 bucket named "advisory-chatbot-tfstate"
#############################################################################################################

# terraform {
#   backend "s3" {
#     bucket = "Bucket-Name"

#     key = "Path with the name of the state file name that will generate"

#     encrypt = "true"
#     region  = "us-east-1"
#   }
# }