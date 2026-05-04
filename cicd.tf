# 1. GitHub OIDC Provider 등록 (AWS 구청에 깃허브 신분증 시스템 등록)
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  # 깃허브의 공인 인증서 지문 (고정값입니다)
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"] 
}

# 2. 깃허브 로봇이 찰 완장(IAM Role) 만들기
resource "aws_iam_role" "github_actions" {
  name = "github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Condition = {
          StringLike = {
            # 🚨 [아주 중요] 조장님의 깃허브 아이디와 앞으로 만들 레포지토리 이름으로 수정하세요!
            # 예시: "token.actions.githubusercontent.com:sub": "repo:ihomin/score-project:*"
            "token.actions.githubusercontent.com:sub": "repo:daniel9939-web/test:*"
          }
        }
      }
    ]
  })
}

# 3. 로봇에게 권한 부여 (원래는 ECR, EKS 권한만 쪼개서 줘야 하지만, 오늘 빠른 테스트를 위해 일단 최고관리자 권한을 줍니다!)
resource "aws_iam_role_policy_attachment" "github_actions_admin" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# 4. 도커 이미지를 보관할 ECR 창고 만들기
resource "aws_ecr_repository" "test_repo" {
  name                 = "score-project-repo"
  image_tag_mutability = "MUTABLE"
  force_delete         = true # 나중에 테라폼 destroy 할 때 창고에 물건이 있어도 강제로 부수게 해주는 옵션!
}