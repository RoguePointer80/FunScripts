function Invoke-EcrLogin
{
  Invoke-Expression (aws ecr get-login --no-include-email --region us-east-1)
}
