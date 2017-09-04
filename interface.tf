variable "name" {
  default = "private"
}
variable "cidrs" {
  description = "A list of CIDR blocks defining the size of the subnets"
  default = []
  type = "list"
}

variable "azs" {
  description = "A list of availability zones to create the subnets in"
  default = []
  type = "list"
}

variable "vpc_id" {
  description = "The VPC to create the subnet in"
  type = "string"
}

variable "nat_gateway_ids" {
  description = "A list of NAT gateway ids to route traffic through"
  default = []
  type = "list"
}

variable "map_public_ip_on_launch" {
  default = "false"
  type = "string"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default = {}
  type = "map"
}