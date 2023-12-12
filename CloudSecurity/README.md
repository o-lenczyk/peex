# Cloud Security  
## L1  
- Single Instance with External IP exists
- Firewall doesn't block TCP Port 22 traffic to instances
- Google Compute Engine instance with External IP is available for connection from your workstation using project-wide OS Login
- Single instance without External IP exists
- Google Compute Engine instance without External IP is available for connection from your workstation, through Google Compute Engine instance with External IP, using project-wide OS Login
- Use IAP tunnel to connect to Google Compute Engine instance without External IP
- Create Compute Engine (GCE) Managed Instance Group (MiG) with Internal IP and any web server with a default web page
- create Load Balancer and attach it to GCE MiG (with all necessary firewall rules based on Instance Tags)
- test if the webpage works from your workstation
- add Cloud Armor rule that denies traffic from your workstation with 403 (Forbidden) error
- test if the webpage returns 403 from your workstation 2min gif

## L2  
- Create GCP Artifact Registry
- Store Docker image in GCP Artifact Registry
- Store Python package in GCP Artifact Registry
- Store Apt package in GCP Artifact Registry
- Create GCP Compute Engine Instance on custom Service Account, grant it proper IAM roles, make sure that it is authorized to pull Docker image from GCP Artifact Registry, then pull any image, that you've pushed before
- GCP Compute Instance is running without External IP, containing any service with authentication (like Basic Auth in Apache/Nginx)
- Secrets with credentials to such service are stored in GCP Secret Manager (for usage with Cloud Function)
- Serverless VPC Connector to the same network (as Compute Instance) exists
- GCP Cloud Function authenticates to service from point 1, using secret from Secret Manager, through a network connection provided by Serverless VPC Connector
- A pipeline consists of access only to secrets that are required.
- GCP Cloud Build is used with secrets as environment variables
- Secrets are stored in GCP Secret Manager
- Proper IAM roles are used to allow Cloud Build service account access secrets
- Create GCP Storage Bucket encrypted by Customer-managed encryption key (CMEK) - Manage via Google Cloud Key Management Service
- Create a Retention policy on a Bucket to prevent data being overwritten during the same day
- Enable versioning on Bucket
- Upload files to your bucket
- Rotate the key to prevent all data being encrypted by a single key
- Upload other files
- Try to overwrite files
- Set permissions on Bucket to work as backend Cloud CDN

## L3
- Configure multi-factor authentication to the infrastructure against the risk of operators losing their credentials.
- Users that connect to a database are identified by their role.
- Users that connect to a CI/CD tool are identified by their role.
- Users that connect to an SCM are identified by their role.
- Users that connect to an artifact repository are identified by their role.
- Services that access other services are identified by their roles.
- Security scanning tests are automatically triggered in a pipeline
- Configure and manage WAF rules across your accounts and applications
