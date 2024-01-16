## L1
- support existing CI
- support existing CD

## L2
- create CI/CD pipeline
- configure [versioning artifacts](https://github.com/o-lenczyk/dietly/blob/master/.github/workflows/build.yml)
- sent [notifications](screenshots/PR-checks.png)
- create [badge](https://github.com/o-lenczyk/dietly/blob/master/README.md)
- integrate SonarQube or SonarCloud into the pipeline:
  - [CodeQL](https://github.com/o-lenczyk/dietly/blob/master/.github/workflows/codeql.yml)
  - [Snyk](https://github.com/o-lenczyk/dietly/blob/master/.github/workflows/snyk-security.yml)
  - [PR validation](screenshots/PR-checks.png)

## L3
- adjust branching strategy
- integrate security scans into the pipeline
- setup testing env

## L4
- desing CI/CD

CI/CD examples: 
- automated creation of GitLab Repositories from teplate using GitLab API [.gitlab-ci.yml](https://gitlab.com/project-factory-test/main/-/blob/main/.gitlab-ci.yml?ref_type=heads)
- Terraform Cloud workspace update [.gitlab-ci.yml](https://gitlab.com/project-factory-test/tf-workspace-update)
- run  terraform [plan, apply, destroy](GitLab/[TERRAFORM].gitlab-ci.yml)
