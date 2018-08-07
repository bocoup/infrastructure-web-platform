# Web Platform Tests Infrastructure

## Bootstrapping
1. Install [AWSCLI] & [Terraform]
2. Ensure `~/.aws/credentials` has an entry with administrative access keys
   matching the `profile` for the project. The profile name can be found in
   `terraform/{project}/variables.tf` under the `provider "aws" {}` block.
3. For projects that integrate with GitHub.com, retrieve a valid access token
   and store it in a file named `token-github.txt` located in the same
   directory as this document.

### Commands Available
The most common lifecycle commands `init`, `plan`, and `apply` have been aliased
in the project's Makefile. If more complex management is needed, just `cd` into
the appropriate `terraform/project/` folder and run terraform directly.

#### make {project}/init
Prepare Terraform to manage the project you've specified. This must be run once
before the other commands are accessible.

#### make {project}/plan
Compare your local configuration to the actual deployed infrastructure and
prepare a plan to reconcile any differences.

#### make {project}/apply
After verifying plan, execute the changes.

[AWSCLI]: http://docs.aws.amazon.com/cli/latest/userguide/installing.html
[Terraform]: https://www.terraform.io/downloads.html
