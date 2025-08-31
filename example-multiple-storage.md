# Multiple Storage Options for Firebase Emulator

## Current Setup ✅
Your emulator now supports multiple storage buckets configuration that will work in production:

- **Main Bucket**: `demo-nomades-webapp.appspot.com`
- **Secondary Bucket**: `demo-nomades-secondary.appspot.com`

Both are accessible via the same Storage emulator at `http://localhost:9199`

## Option 1: Multiple Storage Buckets (Current)

### Configuration Files:
- `src/config/storage.main.rules` - Rules for main bucket
- `src/config/storage.secondary.rules` - Rules for secondary bucket
- `firebase.json` - Configured with multiple storage targets

### Client Code Example:
```javascript
import { getStorage, connectStorageEmulator } from 'firebase/storage';

// Initialize multiple storage buckets
const mainStorage = getStorage(app, "gs://demo-nomades-webapp.appspot.com");
const secondaryStorage = getStorage(app, "gs://demo-nomades-secondary.appspot.com");

// Connect to emulator in development
if (location.hostname === "localhost") {
  connectStorageEmulator(mainStorage, "localhost", 9199);
  connectStorageEmulator(secondaryStorage, "localhost", 9199);
}
```

## Option 2: Multiple Storage Emulator Instances

If you need completely separate storage emulators, you can:

### Docker Compose with Multiple Storage Ports:
```yaml
version: '3.8'
services:
  firebase-emulator-main:
    # Main emulator with storage on 9199
    
  firebase-storage-secondary:
    # Secondary storage emulator on 9200
```

### Client Code:
```javascript
const mainStorage = getStorage(app);
const secondaryStorage = getStorage(app);

connectStorageEmulator(mainStorage, "localhost", 9199);
connectStorageEmulator(secondaryStorage, "localhost", 9200);
```

## How to Use Multiple Buckets

### 1. Upload to Different Buckets:
```javascript
import { ref, uploadBytes } from 'firebase/storage';

// Upload to main bucket
const mainRef = ref(mainStorage, 'public/image.jpg');
await uploadBytes(mainRef, file);

// Upload to secondary bucket (e.g., backups)
const secondaryRef = ref(secondaryStorage, 'backups/image.jpg');
await uploadBytes(secondaryRef, file);
```

### 2. Different Rules for Each Bucket:
- **Main**: Public uploads, private user folders
- **Secondary**: Admin-only backups, system logs

### 3. Environment-Specific Buckets:
- **Main**: User content, public assets
- **Secondary**: Analytics data, system backups
