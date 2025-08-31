# Use the official Node.js runtime as the base image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Install Java (required for Firebase emulators)
RUN apk add --no-cache openjdk11-jre-headless

# Install Firebase CLI globally
RUN npm install -g firebase-tools

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of the project files
COPY . .

# Create directories for saved data and logs
RUN mkdir -p saved-data
RUN mkdir -p logs

# Expose the ports used by Firebase emulators
# UI port
EXPOSE 4000
# Functions port
EXPOSE 5001
# Firestore port
EXPOSE 8090
# Auth port
EXPOSE 9099
# Storage port (default)
EXPOSE 9199
# Hub port
EXPOSE 4400
# Hosting port
EXPOSE 5080

# Set environment variables
ENV FIREBASE_EMULATOR_HUB=0.0.0.0:4400
ENV GCLOUD_PROJECT=demo-nomades-webapp

# Create a non-root user for security
RUN addgroup -g 1001 -S firebase && \
    adduser -S firebase -u 1001 -G firebase

# Change ownership of the app directory to the firebase user
RUN chown -R firebase:firebase /app

# Switch to the firebase user
USER firebase

# Health check to ensure emulators are running
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:4000 || exit 1

# Install curl for health check
USER root
RUN apk add --no-cache curl
USER firebase

# Start the Firebase emulators
CMD ["npm", "start"]
