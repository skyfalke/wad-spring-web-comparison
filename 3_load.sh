#!/bin/bash
set -e

echo "----------"
echo "Check Prometheus for runtime data:"
echo "(1) Request count: http://localhost:9090/graph?g0.expr=increase(http_server_requests_seconds_count%7Buri%3D%22%2Fping%22%2C%20exception%3D%22None%22%7D%5B1m%5D)&g0.tab=0&g0.stacked=0&g0.show_exemplars=0&g0.range_input=5m&g0.step_input=5"
echo "(2) Heap usage: http://localhost:9090/graph?g0.expr=sum%20by%20(name)%20(jvm_memory_used_bytes%7Barea%3D%22heap%22%7D)&g0.tab=0&g0.stacked=0&g0.show_exemplars=0&g0.range_input=5m&g0.step_input=5"
echo "----------"

hey_wad_mvc () {
    echo "Running hey_wad_mvc() ..."
    echo "Writing progress to wad-mvc.log ..."
    echo ""

    # NOTE: During testing, I realized that the Spring MVC sample service
    # consistently failed with 25 concurrent request workers. Therefore,
    # it was futile to go any higher.
    (hey -z 30s -c 5 http://localhost:8081/ping && \
        hey -z 30s -c 10 http://localhost:8081/ping && \
        hey -z 30s -c 15 http://localhost:8081/ping && \
        hey -z 30s -c 20 http://localhost:8081/ping && \
        hey -z 30s -c 25 http://localhost:8081/ping) >wad-mvc.log &
}

hey_wad_webflux_reactor () {
    echo "Running hey_wad_webflux_reactor() ..."
    echo "Writing progress to wad-webflux-reactor.log ..."
    echo ""

    (hey -z 30s -c 5 http://localhost:8082/ping && \
        hey -z 30s -c 10 http://localhost:8082/ping && \
        hey -z 30s -c 15 http://localhost:8082/ping && \
        hey -z 30s -c 20 http://localhost:8082/ping && \
        hey -z 30s -c 25 http://localhost:8082/ping && \
        hey -z 30s -c 50 http://localhost:8082/ping && \
        hey -z 30s -c 75 http://localhost:8082/ping && \
        hey -z 30s -c 100 http://localhost:8082/ping && \
        hey -z 30s -c 125 http://localhost:8082/ping && \
        hey -z 30s -c 150 http://localhost:8082/ping) >wad-webflux-reactor.log &
}

hey_wad_webflux_reactor_coroutines () {
    echo "Running hey_wad_webflux_reactor_coroutines() ..."
    echo "Writing progress to wad-webflux-reactor-coroutines.log ..."
    echo ""
    (hey -z 30s -c 5 http://localhost:8083/ping && \
        hey -z 30s -c 10 http://localhost:8083/ping && \
        hey -z 30s -c 15 http://localhost:8083/ping && \
        hey -z 30s -c 20 http://localhost:8083/ping && \
        hey -z 30s -c 25 http://localhost:8083/ping && \
        hey -z 30s -c 50 http://localhost:8083/ping && \
        hey -z 30s -c 75 http://localhost:8083/ping && \
        hey -z 30s -c 100 http://localhost:8083/ping && \
        hey -z 30s -c 125 http://localhost:8083/ping && \
        hey -z 30s -c 150 http://localhost:8083/ping) >wad-webflux-reactor-coroutines.log &
}

hey_wad_webflux_coroutines () {
    echo "Running hey_wad_webflux_coroutines() ..."
    echo "Writing result to wad-webflux-coroutines.log ..."
    echo ""

    (hey -z 30s -c 5 http://localhost:8084/ping && \
        hey -z 30s -c 10 http://localhost:8084/ping && \
        hey -z 30s -c 15 http://localhost:8084/ping && \
        hey -z 30s -c 20 http://localhost:8084/ping && \
        hey -z 30s -c 25 http://localhost:8084/ping && \
        hey -z 30s -c 50 http://localhost:8084/ping && \
        hey -z 30s -c 75 http://localhost:8084/ping && \
        hey -z 30s -c 100 http://localhost:8084/ping && \
        hey -z 30s -c 125 http://localhost:8084/ping && \
        hey -z 30s -c 150 http://localhost:8084/ping) >wad-webflux-coroutines.log &
}

# NOTE: This is just for demonstration purposes. However, it is better to just 
# perform a single test with a single target service running at any given time.
# That is, launch wad-pong-container & prometheus-container only with one of the
# target service containers (see docker-compose.yaml) and run only the corresponding
# function from this file. For example:
# - wad-mvc-container + hey_wad_mvc
# - wad-webflux-reactor-container + hey_wad_webflux_reactor
# - wad-webflux-reactor-coroutines-container + hey_wad_webflux_reactor_coroutines
# - wad-webflux-coroutines-container + hey_wad_webflux_coroutines
hey_wad_mvc
hey_wad_webflux_reactor
hey_wad_webflux_reactor_coroutines
hey_wad_webflux_coroutines