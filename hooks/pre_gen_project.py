import sys

project_name = "{{ cookiecutter.project_name }}"
if not project_name.isidentifier():
    print("ERROR: Project name must be a valid Python identifier!")
    sys.exit(1)
