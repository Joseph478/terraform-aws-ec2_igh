
locals {
    ami_filters = {
        "tag:PROJECT" = var.project_type
        "tag:ENV" = "PROD"
        root-device-type = "ebs"
        virtualization-type = "hvm"
        architecture = "x86_64"
    }
}
locals {
    root_block_devices = {
        value = {
            delete_on_termination = true
            encrypted = true
            volume_size = var.volume_size
            volume_type = "${var.volume_type}"
        }
    }
}

data "aws_ami" "this" {
    most_recent = true
    owners = ["self"]

    dynamic "filter" {
        for_each = local.ami_filters
        content {
            name = filter.key
            values = [filter.value]
        }
    }
}

resource "aws_security_group" "security_group_ec2" {
    name        = "sg_instance_${var.name_main}"
    description = "Allow inbound traffic"
    vpc_id      = var.vpc_id

    # ingress {
    #   description      = "All Trafic"
    #   from_port        = 0
    #   to_port          = 0
    #   protocol         = "-1"
    #   # cidr_blocks      =  ["192.168.0.0/16"]
    #   security_groups = [aws_security_group.security_group_alb.id]
    # }
    ingress {
        description      = "Trafic HTTP from VPC"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        # ipv6_cidr_blocks = ["::/0"]
    }
    ingress {
        description      = "Trafic HTTPS from VPC"
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        # ipv6_cidr_blocks = ["::/0"]
    }
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        Name = "security_group_ec2"
    }
}

# resource "aws_iam_role" "iam_role_instance_ec2" {
#     name               = "codedeploy-service-role-${var.name_main}"
#     assume_role_policy = file("${path.module}/iamRoles/assumed_role_ec2.json")
#     # falta agregar el rol de donde va a sacar la data
#     managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"]
# }

resource "aws_instance" "this" {
    ami                  = data.aws_ami.this.id
    instance_type        = var.instance_type
    # cpu_core_count       = var.cpu_core_count
    # cpu_threads_per_core = var.cpu_threads_per_core
    # hibernation          = var.hibernation

    # user_data                   = var.user_data
    # user_data_base64            = var.user_data_base64
    # user_data_replace_on_change = var.user_data_replace_on_change

    # availability_zone      = var.availability_zone
    # key_name             = var.key_name

    subnet_id              = var.subnet_id
    vpc_security_group_ids = [aws_security_group.security_group_ec2.id]

    # monitoring           = var.monitoring
    # get_password_data    = var.get_password_data
    iam_instance_profile    = "role_session_manager"

    associate_public_ip_address = var.associate_public_ip_address
    # private_ip                  = var.private_ip
    # secondary_private_ips       = var.secondary_private_ips
    # ipv6_address_count          = var.ipv6_address_count
    # ipv6_addresses              = var.ipv6_addresses

    # ebs_optimized = true

    # dynamic "cpu_options" {
    #     for_each = length(var.cpu_options) > 0 ? [var.cpu_options] : []

    #     content {
    #     core_count       = try(cpu_options.value.core_count, null)
    #     threads_per_core = try(cpu_options.value.threads_per_core, null)
    #     amd_sev_snp      = try(cpu_options.value.amd_sev_snp, null)
    #     }
    # }

    # dynamic "capacity_reservation_specification" {
    #     for_each = length(var.capacity_reservation_specification) > 0 ? [var.capacity_reservation_specification] : []

    #     content {
    #     capacity_reservation_preference = try(capacity_reservation_specification.value.capacity_reservation_preference, null)

    #     dynamic "capacity_reservation_target" {
    #         for_each = try([capacity_reservation_specification.value.capacity_reservation_target], [])

    #         content {
    #         capacity_reservation_id                 = try(capacity_reservation_target.value.capacity_reservation_id, null)
    #         capacity_reservation_resource_group_arn = try(capacity_reservation_target.value.capacity_reservation_resource_group_arn, null)
    #         }
    #     }
    #     }
    # }

    dynamic "root_block_device" {
        for_each = local.root_block_devices

        content {
            delete_on_termination = try(root_block_device.value.delete_on_termination, null)
            encrypted             = try(root_block_device.value.encrypted, null)
            iops                  = try(root_block_device.value.iops, null)
            kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
            volume_size           = try(root_block_device.value.volume_size, null)
            volume_type           = try(root_block_device.value.volume_type, null)
            throughput            = try(root_block_device.value.throughput, null)
            tags                  = try(root_block_device.value.tags, null)
        }
    }

    # dynamic "ebs_block_device" {
    #     for_each = var.ebs_block_device

    #     content {
    #     delete_on_termination = try(ebs_block_device.value.delete_on_termination, null)
    #     device_name           = ebs_block_device.value.device_name
    #     encrypted             = try(ebs_block_device.value.encrypted, null)
    #     iops                  = try(ebs_block_device.value.iops, null)
    #     kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
    #     snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
    #     volume_size           = try(ebs_block_device.value.volume_size, null)
    #     volume_type           = try(ebs_block_device.value.volume_type, null)
    #     throughput            = try(ebs_block_device.value.throughput, null)
    #     tags                  = try(ebs_block_device.value.tags, null)
    #     }
    # }

    # dynamic "ephemeral_block_device" {
    #     for_each = var.ephemeral_block_device

    #     content {
    #     device_name  = ephemeral_block_device.value.device_name
    #     no_device    = try(ephemeral_block_device.value.no_device, null)
    #     virtual_name = try(ephemeral_block_device.value.virtual_name, null)
    #     }
    # }

    # dynamic "metadata_options" {
    #     for_each = length(var.metadata_options) > 0 ? [var.metadata_options] : []

    #     content {
    #     http_endpoint               = try(metadata_options.value.http_endpoint, "enabled")
    #     http_tokens                 = try(metadata_options.value.http_tokens, "optional")
    #     http_put_response_hop_limit = try(metadata_options.value.http_put_response_hop_limit, 1)
    #     instance_metadata_tags      = try(metadata_options.value.instance_metadata_tags, null)
    #     }
    # }

    # dynamic "network_interface" {
    #     for_each = var.network_interface

    #     content {
    #     device_index          = network_interface.value.device_index
    #     network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
    #     delete_on_termination = try(network_interface.value.delete_on_termination, false)
    #     }
    # }

    # dynamic "private_dns_name_options" {
    #     for_each = length(var.private_dns_name_options) > 0 ? [var.private_dns_name_options] : []

    #     content {
    #     hostname_type                        = try(private_dns_name_options.value.hostname_type, null)
    #     enable_resource_name_dns_a_record    = try(private_dns_name_options.value.enable_resource_name_dns_a_record, null)
    #     enable_resource_name_dns_aaaa_record = try(private_dns_name_options.value.enable_resource_name_dns_aaaa_record, null)
    #     }
    # }

    # dynamic "launch_template" {
    #     for_each = length(var.launch_template) > 0 ? [var.launch_template] : []

    #     content {
    #     id      = lookup(var.launch_template, "id", null)
    #     name    = lookup(var.launch_template, "name", null)
    #     version = lookup(var.launch_template, "version", null)
    #     }
    # }

    # dynamic "maintenance_options" {
    #     for_each = length(var.maintenance_options) > 0 ? [var.maintenance_options] : []

    #     content {
    #     auto_recovery = try(maintenance_options.value.auto_recovery, null)
    #     }
    # }

    # enclave_options {
    #     enabled = var.enclave_options_enabled
    # }

    # source_dest_check                    = length(var.network_interface) > 0 ? null : var.source_dest_check
    # disable_api_termination              = var.disable_api_termination
    # disable_api_stop                     = var.disable_api_stop
    # instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
    # placement_group                      = var.placement_group
    # tenancy                              = var.tenancy
    # host_id                              = var.host_id

    # credit_specification {
    #     cpu_credits = local.is_t_instance_type ? var.cpu_credits : null
    # }

    # timeouts {
    #     create = try(var.timeouts.create, null)
    #     update = try(var.timeouts.update, null)
    #     delete = try(var.timeouts.delete, null)
    # }

    tags        = merge({ "Name" = "instance_${var.name_main}" }, var.instance_tags)
    # volume_tags = var.enable_volume_tags ? merge({ "Name" = var.name }, var.volume_tags) : null
}

resource "aws_eip" "eip" {
    instance = aws_instance.this.id
    domain   = "vpc"
}

resource "aws_cloudwatch_metric_alarm" "foobar" {
    alarm_name                  = "awsec2-${aws_instance.this.id}-GreaterThanOrEqualToThreshold-CPUUtilization"
    comparison_operator         = "GreaterThanOrEqualToThreshold"
    evaluation_periods          = 1
    metric_name                 = "CPUUtilization"
    namespace                   = "AWS/EC2"
    period                      = 120
    statistic                   = "Average"
    threshold                   = 80
    alarm_description           = "This metric monitors ec2 cpu utilization"
    dimensions                  = {
        InstanceId = aws_instance.this.id
    }

    alarm_actions = [
        "arn:aws:sns:us-east-1:348484763444:CPU_LIMIT_EC2_ALARM",
        "arn:aws:automate:us-east-1:ec2:reboot"
    ]
}

resource "aws_s3_bucket" "codepipeline_bucket" {
    bucket = var.bucket_name
    # pasarlo a var
    force_destroy = true
}
resource "aws_s3_bucket_ownership_controls" "codepipeline_ownership_controls" {
    bucket = aws_s3_bucket.codepipeline_bucket.id
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}
resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
    depends_on = [ aws_s3_bucket_ownership_controls.codepipeline_ownership_controls ]
    bucket = aws_s3_bucket.codepipeline_bucket.id
    acl    = "private"
}