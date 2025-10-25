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
variable "bucket_name" {
    description = "Type of project"
    type = string
}

# Variables de user_data
variable "user_data" {
    description = "User data to provide when launching the instance"
    type        = string
    default     = null
}

variable "user_data_base64" {
    description = "Can be used instead of user_data to pass base64-encoded binary data directly"
    type        = string
    default     = null
}

variable "user_data_replace_on_change" {
    description = "When used in combination with user_data or user_data_base64 will trigger a destroy and recreate when set to true"
    type        = bool
    default     = null
}

# Variables para el despliegue de Laravel
variable "domain" {
    description = "Dominio para la aplicación Laravel"
    type        = string
    default     = null
}

variable "repo_url" {
    description = "URL del repositorio Git"
    type        = string
    default     = null
}

variable "db_name" {
    description = "Nombre de la base de datos"
    type        = string
    default     = "cv_db_laravel"
}

variable "db_user" {
    description = "Usuario de la base de datos"
    type        = string
    default     = "laravel_user"
}

variable "db_password" {
    description = "Contraseña de la base de datos"
    type        = string
    default     = null
    sensitive   = true
}

variable "user_data" {
    description = "Script de user data para la instancia EC2"
    type        = string
    default     = null
}
