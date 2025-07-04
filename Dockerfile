# Use Ruby 3.4.4
FROM ruby:3.4.4-slim

# Install essential packages
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libyaml-dev \
    libgmp-dev \
    libffi-dev \
    libvips \
    nodejs \
    npm \
    sqlite3 \
    && npm install -g yarn \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Install JavaScript packages
COPY package.json yarn.lock ./
RUN yarn install

# Copy the application code
COPY . .

# Make scripts executable
RUN chmod +x bin/dev docker-entrypoint.sh

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

# Start the application using bin/dev
CMD ["./bin/dev"]