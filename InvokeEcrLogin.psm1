function Invoke-EcrLogin
{
    $region = "us-east-1"
    $account = "064790157154"
    aws ecr get-login-password "--region" "$region" | docker "login" "--username" "AWS" "--password-stdin" "$account.dkr.ecr.$region.amazonaws.com"
}
