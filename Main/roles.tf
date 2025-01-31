resource "aws_iam_role" "Lambda_role" {
    name = "Text_proccessor_lambda_role"

    assume_role_policy = jasoncode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "labda.amazonaws.com"
                }
            }
        ]
    })
}