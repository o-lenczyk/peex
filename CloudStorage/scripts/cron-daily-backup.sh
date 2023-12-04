#!/bin/sh -e
echo "gsutil cp -r /home/mpiase/data/ gs://testing-bucket-with-no-public-access/" > /etc/cron.daily/backup