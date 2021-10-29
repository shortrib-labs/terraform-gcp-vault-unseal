# GCP Vault Unseal

Creates the necessary GCP objects to auto-unseal vault running
in the Shortrib lab.

Reuses code from [Hashicorp's example](https://github.com/hashicorp/vault-guides/tree/master/operations/gcp-kms-unseal).

## Using this Repository

### Prepare a Service Account

To prepare a service account to execute these templates, execute the following steps:

1. Create a service account:

    ```bash
    gcloud iam service-accounts create terraform-vault-unseal \
        --display-name "Vault unseal setup account"

    gcloud iam service-accounts list
    ```

    Set the `$SERVICE_ACCOUNT_EMAIL` variable to match its `email` value.

    ```bash
    SERVICE_ACCOUNT_EMAIL=$(gcloud iam service-accounts list \
      --filter="displayName:Vault unseal setup account" \
      --format 'value(email)')
    ```

3. Assign roles to enable the account to execute

    ```bash
    PROJECT_ID=$(gcloud config get-value project)

    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member serviceAccount:$SERVICE_ACCOUNT_EMAIL \
        --role roles/cloudkms.admin

    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member serviceAccount:$SERVICE_ACCOUNT_EMAIL \
        --role roles/iam.serviceAccountCreator

    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member serviceAccount:$SERVICE_ACCOUNT_EMAIL \
        --role roles/iam.serviceAccountKeyAdmin
    ```

4. Create the service account key and output the file to the `secrets` directory. 

    ```bash
    gcloud iam service-accounts keys create ${SECRETS_DIR}/vault-unseal.json \
        --iam-account $SERVICE_ACCOUNT_EMAIL
    ```

### Prepare a bucket for remote state storage

To maintain Terraform state across systems and users, we'll use GCP to store the remote state.

1. Create the bucket

```bash
BUCKET=<bucket name>

gsutil mb gs://${BUCKET}
gsutil versioning set on gs://${BUCKET}
```

2. Enable access

```bash
gsutil iam ch serviceAccount:${SERVICE_ACCOUNT_EMAIL}:objectAdmin gs://${BUCKET}
```

### Check the variables

Review the values of the Terraform values set in `.envrc` and in [`src/terraform/terraform.tfvars`](src/terraform/terraform.tfvars).

### Create or update the infrastructure

```bash
cd src/terraform
terraform apply
```
