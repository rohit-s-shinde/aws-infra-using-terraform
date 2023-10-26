# Create infrastructure pipeline for ASG Stack

This GitHub Action automates the process of deploying an AWS Auto Scaling Group (ASG) stack using Terraform and AWS CLI. The action consists of multiple stages (Dev, Staging, and Prod), each deploying a different environment. 

## Workflow Configuration

This GitHub Action is triggered when changes are pushed to the `main` branch. It deploys the ASG stack to three different environments: Dev, Staging, and Prod.

### Prerequisites

Before using this GitHub Action, make sure you have configured the following secrets in your GitHub repository settings:

- `AWS_ACCESS_KEY_ID`: Your AWS access key ID.
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret access key.

### Workflow Steps

The workflow is divided into several stages, each responsible for deploying a specific environment:

1. **Dev Stage**:
   - Initializes Terraform for the Dev environment.
   - Applies Terraform to create or update resources in the Dev environment.
   - Configures AWS credentials.
   - Runs an AWS CLI command (you need to specify the command).

2. **Staging Stage**:
   - Initializes Terraform for the Staging environment.
   - Applies Terraform to create or update resources in the Staging environment.
   - Configures AWS credentials.
   - Runs an AWS CLI command (you need to specify the command).

3. **Prod Stage**:
   - Initializes Terraform for the Prod environment.
   - Applies Terraform to create or update resources in the Prod environment.
   - Configures AWS credentials.
   - Runs an AWS CLI command (you need to specify the command).

### Usage

1. Make sure you have configured the required secrets (`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`) in your GitHub repository.

2. Create a GitHub Actions workflow file (e.g., `.github/workflows/deploy-asg.yml`) in your repository and use the following code as an example:

```yaml
name: Deploy ASG Stack

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v2

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v1
        with:
          terraform_version: 1.0.5

      - name: Initialize Terraform (Dev)
        run: terraform init
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}

      - name: Apply Terraform (Dev)
        run: |
          terraform workspace select dev
          terraform apply -auto-approve
          terraform output
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1  # Replace with your desired AWS region

      - name: Run AWS CLI Command
        run: |
          # Your AWS CLI command here
          # aws autoscaling start-instance-refresh --auto-scaling-group-name dev-asg-dashboard --preferences '{"InstanceWarmup": 60, "MinHealthyPercentage": 50}'

  staging:
    needs: dev
    runs-on: ubuntu-latest

    steps:
      # ... (Same steps as Dev but for Staging)

  prod:
    needs: staging
    runs-on: ubuntu-latest

    steps:
      # ... (Same steps as Dev but for Prod)
```

Replace placeholders and customize the AWS CLI command according to your specific deployment requirements.
With this GitHub Action, you can easily deploy your ASG stack to different environments with confidence, knowing that the process is automated and consistent.
