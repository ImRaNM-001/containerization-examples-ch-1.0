#!/usr/bin/env bash

# Configuration
URL="https://github.com/ImRaNM-001/containerization-examples-ch-1.0.git"                
REPO_DIR="containerization-examples-ch-1.0/04-python-fastapi-app"
# BRANCH_NAME="version-3.0"
CONTAINER_NAME="04-python-fastapi-app-cntr"

# Check if required environment variables are set
if [ -z "$BRANCH_NAME" ]; then
    echo "Error: BRANCH_NAME environment variable is not set"
    echo "Usage: export BRANCH_NAME=\"your-branch-name\""
    exit 1
fi

if [ -z "$PORT" ]; then
    echo "Error: PORT environment variable is not set"
    echo "Example Usage: export PORT=\"8081\""
    exit 1
fi

git clone $URL
cd $REPO_DIR
git checkout $BRANCH_NAME

OLD_COMMIT=$(git rev-parse HEAD)		      # Get current commit hash before pull   
git pull origin $BRANCH_NAME

NEW_COMMIT=$(git rev-parse HEAD)		      # Get current commit hash after pull
IMAGE_NAME="04-python-fastapi-app:$(echo $NEW_COMMIT | cut -c1-5)"

if [ "$OLD_COMMIT" != "$NEW_COMMIT" ]; then
	echo "Changes in commit ids, building new docker image"
	# docker rm $(docker ps -q)                     # useful to remove existing containers

    # Build new image with version
    docker build -t $IMAGE_NAME .

# Kill any process running on the specified port to avoid container crash while start
    PIDS=$(sudo lsof -t -i :$PORT)                       # only displays PID's
    if [ -n "$PIDS" ]; then
      echo "Killing processes on port $PORT: $PIDS"
      sudo kill -9 $PIDS
    # Wait a moment to ensure the port is released
      sleep 2
    fi

    # Run new container
    docker run -d --name $CONTAINER_NAME -p $PORT:80 $IMAGE_NAME

else
    echo "No changes detected, skipping rebuild"
fi



#############################################################################
# Usage: User must export both variables before running script
# export BRANCH_NAME="YOUR_BRANCH_NAME"
# export PORT="YOUR_PREFERRED_PORT"
# chmod +x ./rebuild-docker-image.sh
# ./rebuild-docker-image.sh

#############################################################################
