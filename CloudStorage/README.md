# PeEx
## L1
- [Storage Bucket created](https://github.com/o-lenczyk/peex/blob/main/CloudStorage/bucket.tf#L1) (storage class and location of your choice)
- [Storage Bucket data lifecycle](https://github.com/o-lenczyk/peex/blob/main/CloudStorage/bucket.tf#L7) is defined (data lifecycle option of your choice)
- [Use IAM](https://github.com/o-lenczyk/peex/blob/main/CloudStorage/service_account.tf#L26) to manage permissions for your bucket
- [Restrict public access](https://github.com/o-lenczyk/peex/blob/main/CloudStorage/bucket.tf#L41) to your bucket
- [Use KMS](https://github.com/o-lenczyk/peex/blob/main/CloudStorage/bucket.tf#L37) to encrypt data in your Storage Bucket
- [Enable Data Access audit logs](https://github.com/o-lenczyk/peex/blob/main/CloudStorage/audit.tf#L1) to view more logs
- Uploading and downloading objects from the bucket is possible via gsutil [gif](gifs/upload-download.gif)
- Operations on the objects are possible moving, coping, renaming [gif](gifs/move-copy-rename.gif)

## L2
- Retention policy defined: storage class [changes from standard to archive](https://github.com/o-lenczyk/peex/blob/main/CloudStorage/bucket.tf#L17) after the specified time (for testing purposes, it's better to set it for a lower value)
- [Backup Storage Bucket](https://github.com/o-lenczyk/peex/blob/main/CloudStorage/storage-transfer.tf#L6) created
- [Storage Transfer](https://github.com/o-lenczyk/peex/blob/main/CloudStorage/storage-transfer.tf#L36) created to back up data (data is saved in the Backup Storage Bucket,scheduling options of your choice)
- [Storage Transfer can save data](https://github.com/o-lenczyk/peex/blob/main/CloudStorage/storage-transfer.tf#L24) in the backup bucket

## L3
###### Configure high-level access to the bucket object based on the usage of this object  
- new service account, has only read access to single file: [link](https://github.com/o-lenczyk/peex/blob/main/CloudStorage/object.tf#L13)
###### Set up an automated data migration from the storage to the cloud. 
- backup [script](scripts/cron-daily-backup.sh) placed in `/etc/cron.daily`
- systemd [timer](https://github.com/o-lenczyk/peex/blob/main/CloudStorage/scripts/systemd-timer-backup.timer#L1)
###### Use different storage types to store different files based on their purpose
- [auto-expire bucket](https://github.com/o-lenczyk/peex/blob/main/CloudStorage/bucket.tf#L1) is going  through all the storage classes
- [backup bucket](https://github.com/o-lenczyk/peex/blob/main/CloudStorage/storage-transfer.tf#L6) with storage transfer
- [static website bucket](https://github.com/o-lenczyk/peex/blob/main/CloudStorage/static-website.tf#L1) - [link](https://storage.googleapis.com/static.piasecki.it/index.html)

## L4
###### Monitor and set a strategy for storing buckets for an entire project. Define naming convention, access rules, versioning of storage
 - [monitoring](https://console.cloud.google.com/monitoring/dashboards/resourceList/gcs_bucket) of bucket consumption

