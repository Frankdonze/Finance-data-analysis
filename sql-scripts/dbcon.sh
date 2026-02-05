#!/bin/bash
psql "host=$RDSHOST port=5432 dbname=analytics user=dbadmin sslmode=verify-full sslrootcert=/certs/global-bundle.pem password=$PASSWD"
