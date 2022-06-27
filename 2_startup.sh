#!/bin/bash
set -e

podman machine start
docker-compose up
podman container list

echo "----------"
echo "Check Prometheus for runtime data:"
echo "(1) Request count: http://localhost:9090/graph?g0.expr=increase(http_server_requests_seconds_count%7Buri%3D%22%2Fping%22%2C%20exception%3D%22None%22%7D%5B1m%5D)&g0.tab=0&g0.stacked=0&g0.show_exemplars=0&g0.range_input=5m&g0.step_input=5"
echo "(2) Heap usage: http://localhost:9090/graph?g0.expr=sum%20by%20(name)%20(jvm_memory_used_bytes%7Barea%3D%22heap%22%7D)&g0.tab=0&g0.stacked=0&g0.show_exemplars=0&g0.range_input=5m&g0.step_input=5"
echo "----------"

