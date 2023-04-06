#############################################################################################################
# Backend Configurations / State Lock as well (if any)
## Backend Code can be uncommented while runnning the terraform code
# Pre-requisite: Has to create a S3 bucket named "advisory-chatbot-tfstate"
#############################################################################################################

# terraform {
#   backend "s3" {
#     bucket = "optumresearchprod-tf-state"

#     key = "advisory_chatbot/chatbot.tfstate"

#     encrypt = "true"
#     region  = "us-east-1"
#   }
# }