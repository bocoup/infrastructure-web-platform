provider "github" {
  organization = "bocoup"
  token = "${chomp(file("../../../token-github.txt"))}"
}

resource "github_repository_collaborator" "a_repo_collaborator" {
  repository = "web-platform-tests.live"
  username   = "sideshowbarker"
  permission = "push"
}
