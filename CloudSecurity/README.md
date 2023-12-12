# Cloud Security  
## L1  
- [Single Instance](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/vm.tf#L6) with [External IP](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/vm.tf#L31) exists
- Firewall doesn't block [TCP Port 22](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/firewall.tf#L1) traffic to instances
- Google Compute Engine instance with External IP is available for connection from your workstation using project-wide [OS Login](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/os_login.tf#L1)  
[gif](gifs/os-login.gif)
- Single [instance without External IP](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/vm.tf#L43) exists
- Google Compute Engine instance without External IP is available for connection from your workstation, through Google Compute Engine instance with External IP, using [project-wide OS Login](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/vm.tf#L59) (there is no project-wide OS Login, only Org wide OS Login)
- Use IAP tunnel to connect to Google Compute Engine instance without External IP [gif](gifs/iap.gif)
- Create Compute Engine (GCE) Managed Instance Group ([MiG](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/mig.tf#L25)) with Internal IP and any web server with a default web page
- create [Load Balancer](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/load_balacer.tf#L41) and attach it to GCE MiG (with all necessary firewall rules based on Instance Tags)
- test if the webpage works from your workstation
- add Cloud Armor rule that denies traffic from your workstation with 403 (Forbidden) error
- test if the webpage returns 403 from your workstation [2min gif](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/load_balacer.tf#L41)

## L2  
- Create GCP Artifact Registry
- Store [Docker](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/load_balacer.tf#L41) image in GCP Artifact Registry
- Store [Python](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/load_balacer.tf#L41) package in GCP Artifact Registry
- Store [Apt](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/load_balacer.tf#L41) package in GCP Artifact Registry
- Create GCP Compute Engine Instance on custom Service Account, grant it proper [IAM roles](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/load_balacer.tf#L41), make sure that it is authorized to pull Docker image from GCP Artifact Registry, then pull any image, that you've pushed before
- GCP Compute Instance is running without External IP, containing any service with authentication (like Basic Auth in Apache/Nginx)
- [Secrets](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/secret_manager.tf#L6) with [credentials](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/scripts/startup.sh#L1) to such service are stored in GCP Secret Manager (for usage with Cloud Function)
- Serverless [VPC Connector](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/vpc_access.tf#L13) to the same network (as Compute Instance) exists
- GCP [Cloud Function](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/function.tf#L46) authenticates to service from point 1, using [secret from Secret Manager](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/src/main.py#L22), through a network connection provided by Serverless VPC Connector
- A pipeline consists of access only to secrets that are required.
- GCP Cloud Build is used with secrets as environment variables
- Secrets are stored in GCP Secret Manager
- Proper IAM roles are used to allow Cloud Build service account access secrets
- Create GCP Storage [Bucket](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/storage.tf#L35) encrypted by Customer-managed encryption key (CMEK) - Manage via Google Cloud Key Management Service
- Create a [Retention policy](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/storage.tf#L39) on a Bucket to prevent data being overwritten during the same day
- Enable [versioning](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/storage.tf#L43) on Bucket
- Upload files to your bucket
- Rotate the key to prevent all data being encrypted by a single key
- Upload other files
- Try to overwrite files [gif](gifs/keys-versioning.gif)
- [Set permissions](https://github.com/o-lenczyk/peex/blob/main/CloudSecurity/storage.tf#L52) on Bucket to work as backend Cloud CDN

## L3
- Configure multi-factor authentication to the infrastructure against the risk of operators losing their credentials.
- Users that connect to a database are identified by their role.
- Users that connect to a CI/CD tool are identified by their role.
- Users that connect to an SCM are identified by their role.
- Users that connect to an artifact repository are identified by their role.
- Services that access other services are identified by their roles.
- Security scanning tests are automatically triggered in a pipeline
- Configure and manage WAF rules across your accounts and applications
