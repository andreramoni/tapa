resource "aws_iam_user" "u01" {
  name = "u01"
  path = "/"
  force_destroy = "true"
  tags = {
    team = "team01"
  }
}

resource "aws_iam_access_key" "u01" {
  user = "${aws_iam_user.u01.name}"
}

#resource "aws_iam_user_login_profile" "u01" {
#  user    = "${aws_iam_user.u01.name}"
#  pgp_key = "keybase:u01"
#}

output "User ARN  " { value = "${aws_iam_user.u01.arn}" }
output "Access Key" { value = "${aws_iam_access_key.u01.id}" }
output "Secret Key" { value = "${aws_iam_access_key.u01.secret}" }
