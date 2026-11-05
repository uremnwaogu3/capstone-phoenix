output "state_bucket" {
  value = aws_s3_bucket.terraform_state.id
}

output "Lock_table" {
  value = aws_dynamodb_table.lock.name

}