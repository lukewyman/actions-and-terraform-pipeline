# GitHub Actions & Terraform CI/CD Pipeline

This project demonstrates how to build a basic CI/CD Pipeline using GitHub Actions and Terraform. The parts of the pipeline are triggered by opening a pull request from a feature branch, approving the merge into the main branch, and cutting a release.

## The App
The app is dead simple: just an API Gateway REST API directly integrated with a DynamoDB table using openapi 3.0 and AWS openapi extenstions.

## CI/CD Pipeline

### Continuous Integration
The Continuous Integration workflow is in `.github/workflows/ci.yml`. It is triggered by a `pull_request` of activity type `opened` on `feature/**` branches and meets the following goals:
1. Create a Terraform plan and attach it to the pull request
2. Deploy the app to a test environment by applying the Terraform plan from 1.
3. Install the required Python libraries to seed the database and run the integration tests.
4. Run a Python script to seed the DynamoDB table with test data.
5. Run the integration tests using pytest.
6. Tear down the test environment.


### Continuous Deployment: UAT


### Continuous Deployment: Prod