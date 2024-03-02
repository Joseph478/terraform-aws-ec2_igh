variable "name_main" {
    description = "Name MAIN"
    type        = string
}
variable "vpc_id" {
    description = "ID of the VPC"
    type        = string
}
variable "instance_type" {
    description = "The type of instance to start"
    type        = string
    default     = "t3.micro"
}
variable "type_application" {
    description = "The application type currently supports only laravel"
    type        = string
    default     = "laravel"
}
variable "instance_tags" {
    description = "Additional tags for the instance"
    type        = map(string)
    default     = {}
}
variable "subnet_id" {
    description = "Subnet ID"
    type        = string
}
# variable "availability_zone" {
#     description = "AZ to start the instance in"
#     type        = string
#     default     = "us-east-1a"
# }
variable "project_type" {
    description = "Type of project"
    type        = string
}
variable "project_version" {
    description = "Version of project"
    type        = string
}

variable "create_bucket" {
    description = "Boolean to create a bucket"
    type        = bool
}

variable "associate_public_ip_address" {
    description = "Boolean to associate"
    type        = bool
}

variable "associate_elastic_ip_address" {
    description = "Boolean to associate elastic ip"
    type        = bool
}

variable "create_record" {
    description = "Create a record"
    type        = bool 
}

variable "create_alarms" {
    description = "Create alarms"
    type        = bool
}

variable "volume_size" {
    description = "Volume Size"
    type        = number
}

variable "volume_type" {
    description = "Volume Type"
    type        =  string
}

