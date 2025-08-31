# Firebase Emulator Docker Setup

This repository contains a Docker setup for running Firebase emulators locally.

## Services Included

- **Firebase UI**: Port 4000 - Web interface for managing emulated services
- **Firestore**: Port 8090 - NoSQL document database
- **Firebase Auth**: Port 9099 - Authentication service
- **Firebase Functions**: Port 5001 - Serverless functions
- **Firebase Storage**: Port 9199 - File storage service
- **Firebase Hosting**: Port 5080 - Static web hosting
- **Firebase Hub**: Port 4400 - Emulator hub

## Quick Start

### Using Docker Compose (Recommended)

1. **Build and run the container:**
   ```bash
   docker-compose up --build
   ```

2. **Run in background:**
   ```bash
   docker-compose up -d --build
   ```

3. **Stop the container:**
   ```bash
   docker-compose down
   ```

### Using Docker directly

1. **Build the image:**
   ```bash
   docker build -t firebase-emulator .
   ```

2. **Run the container:**
   ```bash
   docker run -p 4000:4000 -p 5001:5001 -p 8090:8090 -p 9099:9099 -p 9199:9199 \
     -v $(pwd)/saved-data:/app/saved-data \
     --name firebase-emulator \
     firebase-emulator
   ```

## Accessing the Services

Once the container is running, you can access:

- **Firebase UI**: http://localhost:4000
- **Firestore**: http://localhost:8090
- **Auth**: http://localhost:9099
- **Functions**: http://localhost:5001
- **Storage**: http://localhost:9199
- **Hosting**: http://localhost:5080
- **Hub**: http://localhost:4400

## Data Persistence

The emulator data is automatically exported to the `saved-data` directory and persisted between container restarts.

## Configuration

The emulator configuration is defined in `firebase.json`. The project is set to `nomades-webapp` as defined in `.firebaserc`.

## Troubleshooting

1. **Check container logs:**
   ```bash
   docker-compose logs firebase-emulator
   ```

2. **Check if all services are running:**
   ```bash
   curl http://localhost:4000
   ```

3. **Restart the container:**
   ```bash
   docker-compose restart firebase-emulator
   ```

## Development

To make changes to the Firebase configuration:

1. Edit `firebase.json` or other configuration files
2. Rebuild the container:
   ```bash
   docker-compose up --build
   ```
