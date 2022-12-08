# GENERAL EKS CLUSTER IN TERRAFORM SCRIPT

# Default EKS ROLE NEEDED FOR LAUNCHING THE EKS CLUSTER
resource "aws_iam_role" "EKS_Cluster_Role" {
  name = "EKSClusterRole"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# ATTACHING THE AWS EKS CLUSTER POLICY TO THE ABOVE ROLE
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy_Attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.EKS_Cluster_Role.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController_Attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.EKS_Cluster_Role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly-EKS" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.EKS_Cluster_Role.name
}

# # CREATING THE EKS CLUSTER
resource "aws_eks_cluster" "ChatBot_EKS_Cluster_Terraform" {
  name     = "ChatBotEKSCluster"
  role_arn = aws_iam_role.EKS_Cluster_Role.arn
  vpc_config {
    subnet_ids = [var.subnet_id_1, var.subnet_id_2, var.subnet_id_3, var.subnet_id_4, var.subnet_id_5]
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role.EKS_Cluster_Role,
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy_Attach,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController_Attach,
  ]
  tags = {
    "Purpose" = "Testing Terraform configuration for EKS"
    "Env"     = "Dev"
  }
  version = 1.23
}

resource "aws_iam_role" "EKS_NodeGroup_Role_Terraform" {
  name = "EKS_NodeGroup_Role_Terraform"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }]
    }
  )
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy_Attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.EKS_NodeGroup_Role_Terraform.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy_Attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.EKS_NodeGroup_Role_Terraform.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly_Attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.EKS_NodeGroup_Role_Terraform.name
}

resource "aws_iam_role_policy_attachment" "EC2InstanceProfileForImageBuilderECRContainerBuilds" {
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  role       = aws_iam_role.EKS_NodeGroup_Role_Terraform.name
}

resource "aws_eks_node_group" "EKS_NodeGroup_Terraform" {
  cluster_name    = aws_eks_cluster.ChatBot_EKS_Cluster_Terraform.name
  node_group_name = "EKS_NodeGroup_Terraform"
  node_role_arn   = aws_iam_role.EKS_NodeGroup_Role_Terraform.arn
  subnet_ids      = [var.subnet_id_1, var.subnet_id_2, var.subnet_id_3, var.subnet_id_4, var.subnet_id_5]
  instance_types  = ["t3.micro"]
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  update_config {
    max_unavailable = 1
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role.EKS_NodeGroup_Role_Terraform,
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy_Attachment,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy_Attachment,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly_Attachment,
  ]
  # Optional: Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size,
      scaling_config[0].max_size
    ]
  }
}





















