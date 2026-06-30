resource "aws_instance" "my_instance" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"

  tags = {
    Name        = "Praktikum-Instance"
    Environment = "LocalStack-Sandbox"
  }
}

# Output untuk memudahkan verifikasi ID instance setelah deploy
output "my_instance_id" {
  value       = aws_instance.my_instance.id
  description = "ID dari EC2 Instance tiruan di LocalStack"
}