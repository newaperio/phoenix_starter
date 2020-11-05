# Infrastructure
This directory contains the [Terraform](https://www.terraform.io/) manifests for building out AWS infrastructure to run the starter

# Goals
- Simplify deployment to AWS through automation
- Provide a solid base for secure infrastructure

# Todo
- [ ] Further flesh out this document
  - [ ] Include steps to set up from nothing
- [ ] Automate as many manual actions as possible
- [ ] Create CI/CD pipeline for automatic deployment to staging on merge to master
- [ ] Create CI/CD pipeline for testing on Pull Request to master
- [ ] Clean up all "Test" resources
- [ ] Lots of refactoring to modularize

# Manual Steps (for now)
- Create `TFState_Test` Role with S3 access. This allows Terraform to manage state of the "Staging" environment in a centralized location
- Create `StagingDeployers_Test` Policy allowing assumption of the `TFState_Test` Role (consult `/infrastructure/temporary/StagingDeployers_Test_Policy.json`)
- Create `StagingDeployers_Test` Group with `StagingDeployers_Test` Policy
- Add users who should be able to deploy to Staging environment to `StagingDeployers_Test` group