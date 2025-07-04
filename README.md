# Recipe Manager

A modern web application for managing and organizing your favorite recipes. Built with Ruby on Rails 7.2 on the backend and Vue.js 3 with Tailwind CSS on the frontend, this application provides a clean, responsive interface for browsing, searching, and managing your recipe collection.

## Features

- 🍽️ Browse and search through your recipe collection
- 📝 Create and edit recipes with rich text formatting
- 🏷️ Categorize recipes with custom categories and colors
- 📱 Responsive design that works on desktop and mobile
- 🖼️ Upload and manage recipe images
- 🔍 Full-text search capabilities
- 📱 Progressive Web App (PWA) ready

## Tech Stack

- **Backend**: Ruby on Rails 7.2
- **Frontend**: Vue.js 3, Pinia (state management)
- **Styling**: Tailwind CSS
- **Database**: SQLite (development), PostgreSQL (production-ready)
- **Build Tool**: esbuild
- **Icons**: Heroicons

## Prerequisites

- Ruby 3.4.4
- Node.js 16+ & Yarn
- SQLite3

## Getting Started

### Prerequisites

- Docker (recommended for easiest setup)
- OR for manual setup:
  - Ruby 3.4.4
  - Node.js 16+ & Yarn
  - SQLite3 (development)

### 1. Clone the repository

```bash
git clone https://github.com/pulsoescolar/recipe-manager.git
cd recipe-manager
```

### 2. Choose your setup method:

#### Option A: Quick Start with Docker (Recommended)

```bash
# Make the script executable if needed
chmod +x docker-dev.sh

# Start the development environment
./docker-dev.sh
```

This will:
- Build the development Docker image
- Set up the database
- Start the development servers
- The application will be available at http://localhost:3000

#### Option B: Manual Setup (without Docker)

1. **Install dependencies**
   ```bash
   # Install Ruby dependencies
   bundle install
   
   # Install JavaScript dependencies
   yarn install
   ```

3. **Set up the database**
   ```bash
   # Create and migrate the database
   rails db:create db:migrate
   
   # Optional: Seed with sample data
   rails db:seed
   ```

4. **Start the development servers**
   ```bash
   # Start Rails server and assets watchers
   bin/dev
   ```
   The application will be available at http://localhost:3000
