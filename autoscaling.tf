# Create AWS launcher config //////////////////////////////////////////////////

resource "aws_launch_configuration" "artash_launch_config" {
  name          = "artash-launch-config"
  image_id      = "ami-0b8b44ec9a8f90422"  # UBUNTU LINUX
  instance_type = "t2.micro"
}

# Create AWS autoscaling_group with maximum 3 EC2 ////////////////////////////

resource "aws_autoscaling_group" "artash_auto_scaling_group" {
  name                 = "artash-auto-scaling-group"
  launch_configuration = aws_launch_configuration.artash_launch_config.name
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2
  vpc_zone_identifier  = [aws_subnet.artash_subnet.id]
}
