output "build_project_name" {
  description = "The name of the CodeBuild project."
  value       = aws_codebuild_project.build_project.name
}
