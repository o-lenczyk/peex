# Cloud Function

## L2  
- Files in a bucket are [created every hour](screenshots/files-every-hour.png), with a name made of current date and time, by [Cloud](https://github.com/o-lenczyk/peex/blob/main/CloudFunction/function.tf#L13)[Function](https://github.com/o-lenczyk/peex/blob/main/CloudFunction/scripts/main.py#L23), triggered by [Cloud Scheduler](https://github.com/o-lenczyk/peex/blob/main/CloudFunction/scheduler.tf#L1) (the target may be i.e. HTTP)
- Authentication is done by [Service Account](https://github.com/o-lenczyk/peex/blob/main/CloudFunction/function.tf#L36)
