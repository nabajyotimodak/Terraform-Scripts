#! /bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo service httpd start  
echo "<h1>Welcome to StackSimplify ! AWS Infra created using Terraform Pub 1<h1>">/var/www/html/index.html