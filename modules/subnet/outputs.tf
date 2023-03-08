output "ids" {
  value       = aws_subnet.subnet[*].id
  description = "Subnet ID List"
}
