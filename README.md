# Deployment Azure Logic Apps by Terraform

## Step 1
Run command in Azure CLI:\
  ```az ad sp create-for-rbac -n "MyLogicApp" --role Contributor```

## Step 2
Export environment variables:
```
export ARM_CLIENT_ID="<appId>"
export ARM_CLIENT_SECRET="<password>"
export ARM_SUBSCRIPTION_ID="<your current subscribtion id>"
export ARM_TENANT_ID="<tenant>"
```

## Step 3
Run command ```terraform init``` to set up a required provider 

## Step 4
Run command ```terraform apply``` to deploy

## Step 5
Run command ```terraform destroy``` to destroy deployment
