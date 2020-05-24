resource "aws_iam_user" "test_user" {
    name = "mysql-test"
}

resource "aws_iam_access_key" "test_user" {
    user = "${aws_iam_user.test_user.name}"
}

resource "aws_iam_user_policy" "test_user_ro" {
    name = "user-policy-test"
    user = "${aws_iam_user.test_user.name}"
    policy= <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::mysql",
                "arn:aws:s3:::mysql/*"
            ]
        }
   ]
}
EOF
}

resource "aws_iam_user" "prod_user" {
    name = "prod"
}

resource "aws_iam_access_key" "prod_user" {
    user = "${aws_iam_user.prod_user.name}"
}

resource "aws_iam_user_policy" "prod_user_ro" {
    name = "prod"
    user = "${aws_iam_user.prod_user.name}"
   policy= <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::mysql",
                "arn:aws:s3:::mysql/*"
            ]
        }
   ]
}
EOF
}

resource "aws_s3_bucket" "prod_bucket" {
    bucket = "mysql-prod"
    acl = "public-read"

    cors_rule {
        allowed_headers = ["*"]
        allowed_methods = ["PUT","POST"]
        allowed_origins = ["*"]
        expose_headers = ["ETag"]
        max_age_seconds = 3000
    }

    policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "PublicReadForGetBucketObjects",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::mysql/*"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${aws_iam_user.prod_user.arn}"
            },
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::mysql",
                "arn:aws:s3:::mysql/*"
            ]
        }
    ]
}
EOF
}

resource "aws_s3_bucket" "test_bucket" {
    bucket = "mysql"
    acl = "public-read"

    cors_rule {
        allowed_headers = ["*"]
        allowed_methods = ["PUT","POST"]
        allowed_origins = ["*"]
        expose_headers = ["ETag"]
        max_age_seconds = 3000
    }

    policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "PublicReadForGetTestBucketObjects",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::mysql/*"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${aws_iam_user.test_user.arn}"
            },
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::mysql",
                "arn:aws:s3:::mysql/*"
            ]
        }
    ]
}
EOF
}