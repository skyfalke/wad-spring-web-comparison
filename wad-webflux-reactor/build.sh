#!/bin/bash
set -e

./mvnw clean package
podman build -t wad/webflux-reactor .