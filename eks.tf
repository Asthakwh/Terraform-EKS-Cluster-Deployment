module "eks" {

     #import the module from the registry
        source = "terraform-aws-modules/eks/aws"
    #source = "terraform-aws-module/eks/aws"
    version = " ~> 19.21.0"
    #cluster information
    cluster_name    = local.name
    #cluster_version = "1.29"
    cluster_endpoint_public_access = true

    vpc_id     = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets
    control_plane_subnet_ids = module.vpc.intra_subnets

    cluster_addons = {
        "vpc-cni" = {
            most_recent = true
        }
        kube-proxy = {
            most_recent = true
        }
        coredns = {
            most_recent = true
        }
    }
# managing nodes in the cluster
    eks_managed_node_group_defaults = {
    instance_types = ["t3.micro"]
    attach_cluster_primary_security_group = true
    }


    eks_managed_node_groups = {
        "demo-cluster-ng" = {
            instance_types = ["t3.micro"]
            min_size       = 1
            max_size       = 3
            desired_size   = 2
            capacity_type   = "SPOT"
        }
    }

    tags = {
        Terraform   = "true"
        Environment = local.env
    }

}