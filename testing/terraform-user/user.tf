resource "aws_iam_user" "u01" {
  name          = "user01"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "lp01" {
  user    = "${aws_iam_user.u01.name}"
  #pgp_key = "keybase:some_person_that_exists"
}

output "password" {
  value = "${aws_iam_user_login_profile.lp01.encrypted_password}"
}

