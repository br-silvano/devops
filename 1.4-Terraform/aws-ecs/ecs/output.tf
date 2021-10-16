output "cluster_id" {
  value = aws_ecs_cluster.main.id
}

output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "load_balancer_ip" {
  value = aws_lb.default.dns_name
}
