module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.5.0"

  name = "score-vpc-tf"
  cidr = "10.0.0.0/16"

  # AZ 2개와 서브넷 4개 쪼개기
  azs             = ["ap-northeast-2a", "ap-northeast-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  # 핵심: NAT 게이트웨이는 돈이 나가니 1개만!
  enable_nat_gateway = true
  single_nat_gateway = true 

  # EKS가 길을 찾기 위한 필수 태그
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}