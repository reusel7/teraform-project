# Create AWS Inet_Gateway /////////////////////////////////////////////////////////////////

resource "aws_internet_gateway" "artash_internet_gateway" {
  vpc_id = aws_vpc.artash_vpc.id
}

# Create AWS routeing-table //////////////////////////////////////////////////////////////

resource "aws_route" "internet_gateway_route" {
  route_table_id         = aws_vpc.artash_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.artash_internet_gateway.id
}


# Create AWS application-load-balancer ////////////////////////////////////////////////////

resource "aws_lb" "artash_alb" {
  name               = "artash-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.artash_SG.id]
  subnets            = [aws_subnet.artash_subnet_1.id, aws_subnet.artash_subnet_2.id]
}

# Create AWS application-load-balancer target group ////////////////////////////////////////////
resource "aws_lb_target_group" "artash_target_group" {
  name        = "artash-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.artash_vpc.id
  target_type = "instance"
}

# Create EC2 with services ///////////////////////////////////////////////////////////////////
resource "aws_instance" "artash_instance1" {
  ami           = "ami-0b8b44ec9a8f90422"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.artash_subnet_1.id
  associate_public_ip_address = true
  security_groups    = [aws_security_group.artash_SG.id]
  user_data     = <<-EOF
    #!/bin/bash
    #Use this for your user data(script from top to bottom)
    #installing Nginx 
    apt update -y
    apt install -y nginx
    systemctl start nginx
    systemctl enamble nginx
    echo "<h1>My First Web Page $(hostname -f)<h1>" | sudo tee /var/www/html/index.html
EOF
  tags = {
    Name = "artash-instance1"
  }
}

resource "aws_instance" "artash_instance2" {
  ami           = "ami-0b8b44ec9a8f90422"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.artash_subnet_1.id
  associate_public_ip_address = true
  security_groups    = [aws_security_group.artash_SG.id]
  user_data     = <<-EOF
    #!/bin/bash
    #Use this for your user data(script from top to bottom)
    #installing Nginx 
    apt update -y
    apt install -y nginx
    systemctl start nginx
    systemctl enamble nginx
    echo "<h1>My First Web Page $(hostname -f)<h1>" | sudo tee /var/www/html/index.html
EOF
  tags = {
    Name = "artash-instance2"
  }
}

resource "aws_lb_target_group_attachment" "artash_attachment1" {
  target_group_arn = aws_lb_target_group.artash_target_group.arn
  target_id        = aws_instance.artash_instance1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "artash_attachment2" {
  target_group_arn = aws_lb_target_group.artash_target_group.arn
  target_id        = aws_instance.artash_instance2.id
  port             = 80
}


resource "aws_lb_listener" "artash_listener" {
  load_balancer_arn = aws_lb.artash_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.artash_target_group.arn
  }
}
