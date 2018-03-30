variable "s3_bucket_name" {

  default = "natoar23ae"
}

variable "sqs_queue_name" {

  default = "natoar23ae"
}

variable "s3_events" {

  type = "list"
  default = ["s3:ObjectCreated:*"]
}

data "aws_iam_policy_document" "queue_policy" {

  statement {

    effect = "Allow"

    principals {
      identifiers = ["*"]
      type = ""
    }

    actions = ["sqs:SendMessage"]
    resources = ["arn:aws:sqs:*:*:${var.sqs_queue_name}"]

    condition {

      test = "ArnEquals"
      variable = "aws:SourceArn"
      values = ["${aws_s3_bucket.bucket.arn}"]
    }
  }
}

resource "aws_sqs_queue" "queue" {

  name = "${var.sqs_queue_name}"
  policy = "${data.aws_iam_policy_document.queue_policy.json}"
}

resource "aws_s3_bucket" "bucket" {

  bucket = "${var.s3_bucket_name}"
}

resource "aws_s3_bucket_notification" "bucket_notification" {

  bucket = "${aws_s3_bucket.bucket.id}"

  queue {
    queue_arn = "${aws_sqs_queue.queue.arn}"
    events = ["s3:ObjectCreated:*"]
  }
}