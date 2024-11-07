#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if Docker is installed
if ! command_exists docker; then
  echo -e "${RED}Docker is not installed. Please install Docker and try again.${NC}"
  exit 1
fi

# Check if Maven is installed
if ! command_exists mvn; then
  echo -e "${RED}Maven is not installed. Please install Maven and try again.${NC}"
  exit 1
fi

# Check if Java 21 JDK is installed
if ! java -version 2>&1 | grep -q "21"; then
  echo -e "${RED}Java 21 JDK is not installed. Please install Java 21 JDK and try again.${NC}"
  exit 1
fi

# Check for --skipTest, --publishToHubDocker, and --noWait flags
SKIP_TESTS=""
PUBLISH_TO_HUB=false
NO_WAIT=false
for arg in "$@"; do
  case $arg in
    --skipTest)
      SKIP_TESTS="-DskipTests"
      shift
      ;;
    --publishToHubDocker)
      PUBLISH_TO_HUB=true
      shift
      ;;
    --noWait)
      NO_WAIT=true
      shift
      ;;
  esac
done

# Function to build and optionally wait
build_and_wait() {
  local service_path=$1
  local image_name=$2
  local skip_maven=$3

  if [ "$NO_WAIT" = false ]; then
    echo -e "${YELLOW}=============================="
    echo "BUILDING ${image_name} IMAGE"
    echo -e "==============================${NC}"
  fi

  cd $service_path
  if [ "$skip_maven" = false ]; then
    mvn clean package $SKIP_TESTS
  fi
  docker build -t $image_name .
  cd -
  echo -e "${GREEN}${image_name} IMAGE BUILT SUCCESSFULLY${NC}"
  echo ""
}

# Capture the start time
start_time=$(date +%s)

# Build images
if [ "$NO_WAIT" = true ]; then
  echo -e "${YELLOW}=============================="
  echo "BUILDING ALL IMAGES"
  echo -e "==============================${NC}"
  build_and_wait "./app/api-gateway" "chiqors/mic-api-gateway:latest" false &
  build_and_wait "./app/frontend-service" "chiqors/mic-frontend-service:latest" true &
  build_and_wait "./app/inventory-service" "chiqors/mic-inventory-service:latest" false &
  build_and_wait "./app/notification-service" "chiqors/mic-notification-service:latest" false &
  build_and_wait "./app/order-service" "chiqors/mic-order-service:latest" false &
  build_and_wait "./app/product-service" "chiqors/mic-product-service:latest" false &
  wait
else
  build_and_wait "./app/api-gateway" "chiqors/mic-api-gateway:latest" false
  build_and_wait "./app/frontend-service" "chiqors/mic-frontend-service:latest" true
  build_and_wait "./app/inventory-service" "chiqors/mic-inventory-service:latest" false
  build_and_wait "./app/notification-service" "chiqors/mic-notification-service:latest" false
  build_and_wait "./app/order-service" "chiqors/mic-order-service:latest" false
  build_and_wait "./app/product-service" "chiqors/mic-product-service:latest" false
fi

# Capture the end time
end_time=$(date +%s)

# Calculate the build duration
build_duration=$((end_time - start_time))
build_minutes=$((build_duration / 60))
build_seconds=$((build_duration % 60))

# Tag and push images to Docker Hub if --publishToHubDocker is provided
if [ "$PUBLISH_TO_HUB" = true ]; then
  echo -e "${YELLOW}=============================="
  echo "PUSHING IMAGES TO DOCKER HUB"
  echo -e "==============================${NC}"

  # Capture the start time for pushing
  push_start_time=$(date +%s)

  if [ "$NO_WAIT" = true ]; then
    echo -e "${YELLOW}=============================="
    echo "PUSHING ALL IMAGES"
    echo -e "==============================${NC}"
    docker push chiqors/mic-api-gateway:latest &
    docker push chiqors/mic-frontend-service:latest &
    docker push chiqors/mic-inventory-service:latest &
    docker push chiqors/mic-notification-service:latest &
    docker push chiqors/mic-order-service:latest &
    docker push chiqors/mic-product-service:latest &
    wait
  else
    docker push chiqors/mic-api-gateway:latest
    docker push chiqors/mic-frontend-service:latest
    docker push chiqors/mic-inventory-service:latest
    docker push chiqors/mic-notification-service:latest
    docker push chiqors/mic-order-service:latest
    docker push chiqors/mic-product-service:latest
  fi

  # Capture the end time for pushing
  push_end_time=$(date +%s)

  # Calculate the push duration
  push_duration=$((push_end_time - push_start_time))
  push_minutes=$((push_duration / 60))
  push_seconds=$((push_duration % 60))

  echo -e "${GREEN}IMAGES PUSHED TO DOCKER HUB SUCCESSFULLY${NC}"
  echo -e "${GREEN}Total push time: ${push_minutes}m ${push_seconds}s (${push_duration}s)${NC}"
  echo -e "${GREEN}Total build time: ${build_minutes}m ${build_seconds}s (${build_duration}s)${NC}"
else
  echo -e "${YELLOW}=============================="
  echo "ALL IMAGES HAVE BEEN BUILT SUCCESSFULLY"
  echo -e "==============================${NC}"
  echo -e "${GREEN}Total build time: ${build_minutes}m ${build_seconds}s (${build_duration}s)${NC}"
fi