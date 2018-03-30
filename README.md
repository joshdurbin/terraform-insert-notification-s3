# terraform-insert-notification-s3
An s3 bucket, policy definition, sns, and sqs.

# variables

- s3_bucket_name -- the name of the bucket to create
- sqs_queue_name -- the name of the queue to
- s3_events -- a list of s3 events to propagate (defaults to `s3:ObjectCreated:*`)