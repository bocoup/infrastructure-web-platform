PROJECTS_DIR = terraform/projects
PROJECTS = $(notdir $(wildcard $(PROJECTS_DIR)/*))
PROJECT_FROM_TARGET = $(firstword $(subst /, ,$1))

.PHONY: init plan apply %/init %/plan %/apply

%/init %/plan %/apply: project = $(call PROJECT_FROM_TARGET, $@)

%/init:
	cd $(PROJECTS_DIR)/$(project) && terraform init

%/plan:
	cd $(PROJECTS_DIR)/$(project) && terraform plan -out $(project).plan

%/apply:
	cd $(PROJECTS_DIR)/$(project) && terraform apply $(project).plan
