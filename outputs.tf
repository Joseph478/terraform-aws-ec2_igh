output "instance_id" {
    value = aws_instance.this.id
}

output "instance_arn" {
    value = aws_instance.this.arn
}

output "private_ip" {
    value = aws_instance.this.private_ip
}

output "public_ip" {
    value = aws_eip.eip.public_ip
}

output "private_dns" {
    value = aws_instance.this.private_dns
}

output "id_security_group_ec2" {
    value = aws_security_group.security_group_ec2.id
}

output "eip_id" {
    value = aws_eip.eip.id
}

output "eip_allocation_id" {
    value = aws_eip.eip.allocation_id
}

output "s3_bucket_id" {
    value = aws_s3_bucket.codepipeline_bucket.id
}

output "s3_bucket_arn" {
    value = aws_s3_bucket.codepipeline_bucket.arn
}
