
# Subnet
resource "aws_subnet" "private" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${element(var.cidrs, count.index)}"
  availability_zone       = "${element(var.azs, count.index)}"
  count                   = "${length(var.cidrs)}"
  map_public_ip_on_launch = "false"
  
  tags = "${merge(var.tags, map("Name", format("%s.%s", var.name, element(var.azs, count.index))))}"
}

# Routes
resource "aws_route_table" "private" {
  vpc_id = "${var.vpc_id}"
  count  = "${length(var.cidrs)}"

  tags = "${merge(var.tags, map("Name", format("%s.%s", var.name, element(var.azs, count.index))))}"
}

resource "aws_route_table_association" "private" {
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  count          = "${length(var.cidrs)}"
}

resource "aws_route" "nat_gateway" {
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(var.nat_gateway_ids, count.index)}"
  count                  = "${length(var.cidrs)}"

  depends_on             = [
    "aws_route_table.private"
  ]
}

# Output
output "subnet_ids" {
  value = [
    "${aws_subnet.private.*.id}"
  ]
}

output "private_route_table_ids" {
  value = [
    "${aws_route_table.private.*.id}"
  ]
}
