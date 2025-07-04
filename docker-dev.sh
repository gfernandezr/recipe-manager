#!/bin/bash

# Build the Docker image
docker build -t recipe-manager .

# Run the Docker container
docker run -it --rm \
  -p 3000:3000 \
  -p 3035:3035 \
  -v $(pwd):/app \
  -v /app/node_modules \
  -v /app/tmp \
  -v /app/public/packs \
  -e RAILS_ENV=development \
  -e NODE_ENV=development \
  -e RAILS_SERVE_STATIC_FILES=true \
  -e RAILS_BIND=0.0.0.0 \
  -e WEB_CONCURRENCY=0 \
  --name recipe-manager \
  recipe-manager