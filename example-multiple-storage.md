# Multiple Storage Options for Firebase Emulator

## Current Setup ✅
Your emulator now supports multiple storage buckets configuration that will work in production:

- **Private Bucket**: `nomades-webapp.appspot.com`
- **Public Bucket**: `nogal-public`

Both are accessible via the same Storage emulator at `http://localhost:9199`

## Option 1: Multiple Storage Buckets (Current)

### Configuration Files:
- `src/config/storage.private.rules` - Rules for private bucket
- `src/config/storage.public.rules` - Rules for public bucket
- `firebase.json` - Configured with multiple storage targets

### Client Code Example:
```javascript
import { getStorage, connectStorageEmulator } from 'firebase/storage';

// Initialize multiple storage buckets
const privateStorage = getStorage(app, "gs://nomades-webapp.appspot.com");
const publicStorage = getStorage(app, "gs://nogal-public");

// Connect to emulator in development
if (location.hostname === "localhost") {
  connectStorageEmulator(privateStorage, "localhost", 9199);
  connectStorageEmulator(publicStorage, "localhost", 9199);
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
const privateStorage = getStorage(app);
const publicStorage = getStorage(app);

connectStorageEmulator(privateStorage, "localhost", 9199);
connectStorageEmulator(publicStorage, "localhost", 9200);
```

## How to Use Multiple Buckets

### 1. Upload to Different Buckets:
```javascript
import { ref, uploadBytes } from 'firebase/storage';

// Upload to private bucket (user-specific content)
const privateRef = ref(privateStorage, 'user/123/profile.jpg');
await uploadBytes(privateRef, file);

// Upload to public bucket (public assets)
const publicRef = ref(publicStorage, 'assets/logo.png');
await uploadBytes(publicRef, file);
```

### 2. Different Rules for Each Bucket:
- **Private**: User-specific content, admin areas, premium features
- **Public**: Public assets, uploads, cached content

### 3. Use Cases:
- **Private**: Personal files, admin documents, premium content
- **Public**: App assets, public uploads, CDN content
