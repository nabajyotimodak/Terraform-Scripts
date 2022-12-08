# Define Output Values

output "endpoint" {
  value       = aws_eks_cluster.ChatBot_EKS_Cluster_Terraform.endpoint
  description = "Detaild of the endpoint of the cluster"
}
