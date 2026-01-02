#!/bin/bash

aws s3 sync ../data/bronze s3://bron-silv-data/bronze
aws s3 sync ../data/silver s3://bron-silv-data/silver
