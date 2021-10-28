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

    ```bash
    gcloud iam service-accounts list
    ```

    Set the `$SERVICE_ACCOUNT_EMAIL` variable to match its `email` value.

    ```bash
    SERVICE_ACCOUNT_EMAIL=$(gcloud iam service-accounts list \
      --filter="displayName:Velero service account" \
      --format 'value(email)')
    ```

3. Attach policies to enable the account to execute

    ```bash
    ROLE_PERMISSIONS=(
      cloudkms.cryptoKeyVersions.create
      cloudkms.cryptoKeyVersions.destroy
      cloudkms.cryptoKeyVersions.get
      cloudkms.cryptoKeyVersions.list
      cloudkms.cryptoKeyVersions.restore
      cloudkms.cryptoKeyVersions.update
      cloudkms.cryptoKeyVersions.useToDecryptViaDelegation
      cloudkms.cryptoKeyVersions.useToEncryptViaDelegation
      cloudkms.cryptoKeys.*
      cloudkms.importJobs.*
      cloudkms.keyRings.*
      cloudkms.locations.get
      cloudkms.locations.list
      resourcemanager.projects.get
      cloudkms.cryptoKeyVersions.create
      cloudkms.cryptoKeyVersions.get
      cloudkms.cryptoKeyVersions.list
      cloudkms.cryptoKey.create
      cloudkms.cryptoKey.get
      cloudkms.cryptoKey.list
      cloudkms.keyRings.create
      cloudkms.keyRings.get
      cloudkms.locations.get
      cloudkms.locations.list
      resourcemanager.projects.get
    )

    gcloud iam roles create terraform.unseal \
        --project $PROJECT_ID \
        --title "Create/maintain vault auto-unseal infrastructure" \
        --permissions "$(IFS=","; echo "${ROLE_PERMISSIONS[*]}")"

    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member serviceAccount:$SERVICE_ACCOUNT_EMAIL \
        --role projects/$PROJECT_ID/roles/terraform.unseal
    ```

4. Create the service account key and output the file to the `secerts` directory. 

    ```bash
    gcloud iam service-accounts keys create credentials-velero \
        --iam-account $SERVICE_ACCOUNT_EMAIL
    ```


### Check the variables

Review the values of the Terraform values set in `.envrc` and in [`src/terraform/terraform.tfvars`](src/terraform/terraform.tfvars).

### Create or update the infrastructure

```bash
cd src/terraform
terraform apply
```
