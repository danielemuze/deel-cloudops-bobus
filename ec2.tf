resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "your_public_key_here"
}
resource "aws_launch_template" "web" {
  name_prefix       = "web-launch-configuration-"
  image_id          = "ami-0e001c9271cf7f3b9"  # Ubuntu Server 22.04 LTS (HVM), SSD Volume Type
  instance_type     = "t2.micro"
  vpc_security_group_ids   = [aws_security_group.web.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }
  key_name          = aws_key_pair.deployer.key_name

  user_data = filebase64("${path.module}/user_data.sh")
}

resource "aws_autoscaling_group" "web" {
  min_size             = 2
  max_size             = 4
  desired_capacity     = 2
  vpc_zone_identifier  = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "DockerWebApp"
    propagate_at_launch = true
  }

  # Attach the Auto Scaling group to the ELB
  depends_on = [aws_lb.web]
}
