# GitHub Actions & Terraform CI/CD Pipeline

This project is planned as a demonstration of how to build a basic CI/CD Pipeline using GitHub Actions and Terraform. As of this time, only the terraform-deployable app is complete. I will update this repo as I complete each pipeline part.

## The App
The app is dead simple: just an API Gateway REST API directly integrated with a DynamoDB table using openapi 3.0 and AWS openapi extenstions.

## CI/CD Pipeline
**The following outlines the GitHub Actions work I have planned for this project**

### Continuous Integration
The following outlines how this workflow is expected to run when triggered by a `pull_request` of activity type `opened` on `feature/**` branches and meets the following goals:

1. Checkout the code with `actions/checkout@v3`.
2. Setup Terraform with `hashicorp/setup-terraform@v2`.
3. Check that the Terraform code is formatted correctly.
4. Initialize Terraform for the `test` environment (where `TF_WORKSPACE=test`).
5. Deploy the infrastructure to the `test` environment.
6. Run a python script to seed the DynamoDB table.
7. Run the integration tests against the API in `test` with pytest.
8. Tear down the `test` environment.
9. Initialize Terraform for the `uat` (staging) environment.
10. Run `terraform plan` for the `uat` environment.
11. Update the pull request with the Terraform plan.


### Continuous Deployment: UAT
The following outlines how this workflow is expected to run when triggered by a `pull_request` of activity type `closed` (when the pull request is approved and merged):

1. Checkout the code with `actions/checkout@v3`.
2. Setup Terraform with `hashicorp/setup-terraform@v2`.
3. Check that the Terraform code is formatted correctly.
4. Initialize Terraform for the `uat` (staging) environment.
5. Deploy the infrastructure to the `uat` environment by applying the Terraform plan attached to the pull request.
