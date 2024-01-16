#!/bin/bash

PGPASSWORD=changeme pg_dump        \
"sslmode=verify-ca                 \
sslrootcert=server-ca.pem          \
sslcert=client-cert.pem            \
sslkey=client-key.pem              \
hostaddr=35.184.178.20             \
port=5432                          \
user=orest                         \
dbname=my-database" |              \
PGPASSWORD=changeme                \
psql                               \
"sslmode=verify-ca                 \
sslrootcert=keys-new/server-ca.pem \
sslcert=keys-new/client-cert.pem   \
sslkey=keys-new/client-key.pem     \
hostaddr=34.116.179.228            \
port=5432                          \
user=orest                         \
dbname=dietly"