# Comment
// Comment
/* Block comment */

terraform {
  required_version = ">= 1.5.0, < 2.0.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

variable "name" {
  type      = string
  default   = "demo"
  sensitive = true
  validation {
    condition     = length(var.name) > 2 && var.name != null
    error_message = "Name too short."
  }
}
variable "shape" {
  type    = object({ a = string, b = optional(number, 3), c = bool, d = list(string), e = set(string), f = map(any) })
  default = { a = "x", b = null, c = true, d = ["p"], e = ["q"], f = { big = 1e3, neg = -1.5 } }
}

locals {
  merged = merge({ env = "dev" }, var.shape.f)
  ids    = [for i in var.shape.d : format("%s-%d", i, var.shape.b) if i != ""]
  keyed  = { for k, v in var.shape.f : upper(k) => try(tostring(v), null) }
  flag   = coalesce(lookup(var.shape.f, "big", null), 0) > 0 ? jsonencode({ ok = true }) : "no"
}

data "aws_ami" "this" { most_recent = true }

resource "aws_instance" "web" {
  provider      = aws.west
  count         = var.shape.b
  ami           = data.aws_ami.this.id
  instance_type = "t3.${var.name}"
  user_data     = <<-EOT
    echo "${var.name}-${count.index}"
  EOT
  tags          = merge(local.merged, { Name = local.flag })
  dynamic "ebs_block_device" {
    for_each = var.shape.e
    content { device_name = each.key }
  }
  lifecycle { ignore_changes = [tags, ami] }
}

module "vpc" {
  source     = "terraform-aws-modules/vpc/aws"
  version    = "5.8.1"
  for_each   = toset(["a", "b"])
  name       = each.value
  depends_on = [data.aws_ami.this]
}

output "ips" {
  description = <<EOT
private addresses
EOT
  value       = aws_instance.web[*].private_ip
  depends_on  = [module.vpc]
}
