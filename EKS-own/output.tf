# Define Output Values

output "endpoint" {
  value       = aws_eks_cluster.ChatBot_EKS_Cluster_Terraform.endpoint
  description = "Detaild of the endpoint of the cluster"
}

output "kubeconfig-certificate-authority-data" {
  value       = aws_eks_cluster.ChatBot_EKS_Cluster_Terraform.certificate_authority[0].data
  description = "Details of kubeconfig data"
}

