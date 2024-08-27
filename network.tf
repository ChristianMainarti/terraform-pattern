resource "aws_vpc" "prod-vpc" {
    cidr_block = "10.10.0.0/16"
    enable_dns_hostnames = true
    tags = {
        Name = "environment-vpc"
        Application= "app name"
        Environment = ""
    }
}

resource "aws_subnet" "subnet1"{
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = "10.10.2.0/24"
    map_public_ip_on_launch = false
    tags={
        name = "prod-pvt-appname-subnet-us-east-2a"
    }
}

resource "aws_subnet" "subnet2"{
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = "10.10.3.0/24"
    map_public_ip_on_launch = false
    tags={
        name = "prod-pvt-appname-subnet-us-east-2b"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.prod-vpc.id
    tags = {
        Name = "prod-pvt-igw-us-east-2"
    }
}

resource "aws_route_table" "rtb" {
    vpc_id = aws_vpc.prod-vpc.id
    route {
        cidr_block = "10.0.0.0/16"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
    Name = "prod-appname-rtb-us-east-2-pvt"
    }
}

resource "aws_route_table_association" "rtb-association1" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id =  aws_route_table.rtb.id
}

resource "aws_route_table_association" "rtb-association2" {
    subnet_id = aws_subnet.subnet2.id
    route_table_id =  aws_route_table.staging-rtb-pvt.id
}

resource "aws_security_group" "SG-for-RDS" {
    description = ""
    vpc_id = aws_vpc.prod-vpc.id
    tags = {
        name = "prod-pvt-igw-us-east-2"
        Application = "app name"
        Environment = "environment"
    }
}

resource "aws_vpc_security_group_ingress_rule" "allow_pg" {
    security_group_id = aws_security_group.SG-for-RDS.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 5432
    to_port = 5432
    ip_protocol = "tcp"
    description = "allow trafic from ECS to RDS"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_1" {
    security_group_id = aws_security_group.SG-for-RDS.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
        description = "allow trafic ipv4 from ECS to RDS"
}

resource "aws_security_group" "SG-for-ECS" {
    description = ""
    vpc_id = aws_vpc.prod-vpc.id
    tags = {
        name = "prod-appname-sg-us-east-2-ecs"
        Application = "app name"
        Environment = "environment"
    }
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_traffic" {
    security_group_id = aws_security_group.SG-for-ECS.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = "-1"
    to_port = "-1"
    ip_protocol = "-1"
    description = "allow all trafic to ECS"
}

resource "aws_vpc_security_group_ingress_rule" "allow_https1" {
    security_group_id = aws_security_group.SG-for-ECS.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
    description = "allow https trafic to ECS"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_2" {
    security_group_id = aws_security_group.SG-for-ECS.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
        description = "allow all trafic from ECS"
}

resource "aws_security_group" "SG-for-ALB" {
    description = ""
    vpc_id = aws_vpc.prod-vpc.id
    tags = {
        name = "prod-appname-sg-us-east-2-alb"
        Application = "app name"
        Environment = "environment"
    }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https2" {
    security_group_id = aws_security_group.SG-for-ALB.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
    description = "allow https trafic"
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
    security_group_id = aws_security_group.SG-for-ALB.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    ip_protocol = "http"
    description = "allow http trafic"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
    security_group_id =  aws_security_group.SG-for-ALB.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

