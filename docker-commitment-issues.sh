#!/bin/bash

# Docker Commitment Issues - Because you can't commit to stopping containers
# A tool for developers who treat Docker containers like bad relationships

set -e

# Color codes for emotional impact
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color (like your commitment)

function show_help() {
    echo "Docker Commitment Issues - Because 'docker ps' is too mainstream"
    echo "Usage: $0 [command]"
    echo "Commands:"
    echo "  list    - Show running containers (default)"
    echo "  stop    - Stop ALL running containers (commitment issues)"
    echo "  ports   - Show what's hogging your favorite ports"
    echo "  help    - Show this message (you need it)"
}

function list_containers() {
    echo -e "${YELLOW}Your current commitments (that you'll probably abandon):${NC}"
    echo "=================================================="
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    echo ""
    
    # Show resource usage for extra guilt
    echo -e "${YELLOW}Resources you're wasting right now:${NC}"
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" 2>/dev/null || \
        echo "(Stats require Docker daemon love)"
}

function stop_all_containers() {
    echo -e "${RED}⚠️  Commitment Issues Activated! ⚠️${NC}"
    echo "Breaking up with ALL running containers..."
    
    running=$(docker ps -q)
    if [[ -z "$running" ]]; then
        echo -e "${GREEN}No containers to dump. You're free!${NC}"
        return
    fi
    
    echo "Dumping containers: $(echo $running | wc -w) relationships"
    docker stop $running
    echo -e "${GREEN}All containers stopped. You're single again!${NC}"
}

function show_ports() {
    echo -e "${YELLOW}Ports currently in relationships:${NC}"
    echo "=================================================="
    
    # Get all exposed ports from running containers
    docker ps --format "{{.Ports}}" | grep -oE "[0-9]+->" | grep -oE "[0-9]+" | sort -n | uniq | \
    while read port; do
        echo -e "Port ${RED}${port}${NC} is taken (probably by your last project)"
    done
    
    # Check common dev ports for extra sass
    common_ports=(3000 4200 8080 8000 5432 6379 27017)
    echo ""
    echo -e "${YELLOW}Checking your favorite excuses:${NC}"
    for port in "${common_ports[@]}"; do
        if lsof -i :$port >/dev/null 2>&1; then
            echo -e "Port ${RED}${port}${NC} - 'Something is already using this port' (it's you)"
        fi
    done
}

# Main execution (like your attention span)
case "${1:-list}" in
    list)
        list_containers
        ;;
    stop)
        stop_all_containers
        ;;
    ports)
        show_ports
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Unknown commitment: $1"
        show_help
        exit 1
        ;;

esac

# Remember: It's not ghosting if they're Docker containers
