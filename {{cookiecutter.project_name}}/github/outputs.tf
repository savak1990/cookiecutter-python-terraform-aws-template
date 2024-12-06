output "repository_ssh_url" {
  description = "The SSH URL of the created GitHub repository"
  value       = github_repository.repo.ssh_clone_url
}

output "repository_https_url" {
  description = "The HTTPS URL of the created GitHub repository"
  value       = github_repository.repo.http_clone_url
}
