module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.5.0"

  cluster_name    = "score-cluster-tf"
  cluster_version = "1.35"

  # 클러스터 엔드포인트 퍼블릭 액세스 허용 (내 노트북에서 접속 가능하게)
  cluster_endpoint_public_access = true

  # 아까 만든 VPC와 프라이빗 서브넷에 연결
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets

  # 워커 노드(EC2) 그룹 설정
  eks_managed_node_groups = {
    score_nodes = {
      min_size     = 2
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.small"]
      capacity_type  = "SPOT" # 저렴한 스팟 인스턴스 사용
    }
  }

  # 클러스터 생성자(조장님)에게 최고 관리자 권한 자동 부여
  enable_cluster_creator_admin_permissions = true
}