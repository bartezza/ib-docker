#!/bin/bash

set -e

IMAGE=bart-ib-docker

docker build -t $IMAGE .
