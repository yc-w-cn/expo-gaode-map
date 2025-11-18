# Initialization Guide

English | [简体中文](./INITIALIZATION.md)

This document explains how to properly initialize and configure expo-gaode-map.

## Table of Contents

- [Basic Initialization Process](#basic-initialization-process)
- [Permission Management](#permission-management)
- [Complete Example](#complete-example)
- [Common Issues](#common-issues)

## Basic Initialization Process

### 1. SDK Initialization

Initialize the SDK when the app starts (usually in the App component's useEffect):

```tsx
import { initSDK } from 'expo-gaode-map';

useEffect(() => {
  initSDK({
    androidKey: 'your-android-api-key',
    iosKey: 'your-ios-api-key',
  });
}, []);
```

### 2. Permission Check and Request

Before using location features, you must check and request permissions:

```tsx
import { 
  checkLocationPermission, 
  requestLocationPermission 
} from 'expo-gaode-map';

// Check permission status
const status = await checkLocationPermission();
console.log('Permission status:', status);
// { granted: boolean, canAskAgain: boolean }

// Request permission
if (!status.granted) {
  const result = await requestLocationPermission();
  if (result.granted) {
    console.log('Permission granted');
  } else {
    console.log('Permission denied');
  }
}
```

### 3. Get Location

After permission is granted, you can get the current location:

```tsx
import { getCurrentLocation } from 'expo-gaode-map';

try {
  const location = await getCurrentLocation();
  console.log('Current location:', location);
} catch (error) {
  console.error('Get location failed:', error);
}
```

## Permission Management

### Permission APIs

| API | Description | Return Value |
|-----|-------------|--------------|
| `checkLocationPermission()` | Check location permission status | `Promise<PermissionStatus>` |
| `requestLocationPermission()` | Request location permission | `Promise<PermissionStatus>` |

### PermissionStatus Type

```typescript
interface PermissionStatus {
  granted: boolean;      // Whether permission is granted
  canAskAgain: boolean;  // Whether can request again
}
```

### Permission Status Explanation

- **granted: true** - User granted permission, can use location features
- **granted: false, canAskAgain: true** - User denied permission, but can request again
- **granted: false, canAskAgain: false** - User permanently denied permission, need to guide user to settings

## Complete Example

### Recommended Initialization Process

```tsx
import { useEffect, useState } from 'react';
import { Alert, Platform, Linking } from 'react-native';
import { 
  MapView,
  initSDK,
  checkLocationPermission,
  requestLocationPermission,
  getCurrentLocation,
  type LatLng,
} from 'expo-gaode-map';

export default function App() {
  const [initialPosition, setInitialPosition] = useState<{
    target: LatLng;
    zoom: number;
  } | null>(null);

  useEffect(() => {
    const initializeApp = async () => {
      try {
        // 1. Initialize SDK
        console.log('Initializing AMap SDK...');
        initSDK({
          androidKey: 'your-android-api-key',
          iosKey: 'your-ios-api-key',
        });
        
        // 2. Check permission
        const status = await checkLocationPermission();
        
        // 3. Request permission if needed
        if (!status.granted) {
          const result = await requestLocationPermission();
          
          if (!result.granted) {
            // Permission denied, use default location
            console.log('Location permission denied, using default location');
            setInitialPosition({
              target: { latitude: 39.90923, longitude: 116.397428 },
              zoom: 10
            });
            
            // Guide user to settings if cannot ask again
            if (!result.canAskAgain) {
              Alert.alert(
                'Location Permission Required',
                'Please enable location permission in settings',
                [
                  { text: 'Cancel', style: 'cancel' },
                  { text: 'Settings', onPress: () => {
                    if (Platform.OS === 'ios') {
                      Linking.openURL('app-settings:');
                    } else {
                      Linking.openSettings();
                    }
                  }}
                ]
              );
            }
            return;
          }
        }
        
        // 4. Get current location
        const location = await getCurrentLocation();
        console.log('Current location:', location);
        
        // 5. Set map initial position
        setInitialPosition({
          target: {
            latitude: location.latitude,
            longitude: location.longitude
          },
          zoom: 15
        });
        
      } catch (error) {
        console.error('Initialization failed:', error);
        // Use default location
        setInitialPosition({
          target: { latitude: 39.90923, longitude: 116.397428 },
          zoom: 10
        });
      }
    };

    initializeApp();
  }, []);

  // Wait for initialization
  if (!initialPosition) {
    return <LoadingScreen />;
  }

  return (
    <MapView
      style={{ flex: 1 }}
      initialCameraPosition={initialPosition}
      myLocationEnabled={true}
      onLoad={() => console.log('Map loaded')}
    />
  );
}
```

### Key Points

1. **Initialization Order**:
   ```
   initSDK → checkPermission → requestPermission → getCurrentLocation → Render Map
   ```

2. **Permission Handling**:
   - ✅ Always check permission status first
   - ✅ Only request permission when needed
   - ✅ Handle permission denial cases
   - ✅ Provide default location as fallback

3. **Map Rendering**:
   - ✅ **Important**: Wait for `initialPosition` to be set before rendering MapView
   - ✅ Use `initialCameraPosition` to set initial position
   - ⚠️ **iOS Note**: If map is rendered before getting location, it will show default location (Beijing) first then jump, causing flicker
   - ✅ Both Android and iOS will directly position to specified location when map is displayed

## Common Issues

### Q: How to handle user denying permission?

**A:** Provide default location and guide user:

```tsx
if (!result.granted) {
  // Use default location
  setInitialPosition({
    target: { latitude: 39.90923, longitude: 116.397428 },
    zoom: 10
  });
  
  // Guide to settings if cannot ask again
  if (!result.canAskAgain) {
    Alert.alert(
      'Location Permission Required',
      'Please enable location permission in settings',
      [
        { text: 'Cancel' },
        { text: 'Settings', onPress: () => Linking.openSettings() }
      ]
    );
  }
}
```

### Q: Can I update location after map is loaded?

**A:** Yes, use the `moveCamera` method:

```tsx
const mapRef = useRef<MapViewRef>(null);

// Update map center
await mapRef.current?.moveCamera({
  target: { latitude: 40.0, longitude: 116.5 },
  zoom: 15,
}, 1000); // 1 second animation
```

### Q: How to configure location parameters?

**A:** Use the `configure` function, **must be called after `initSDK`**:

```tsx
import { initSDK, configure } from 'expo-gaode-map';

// 1. Initialize SDK first
initSDK({
  androidKey: 'your-android-api-key',
  iosKey: 'your-ios-api-key',
});

// 2. Then configure location parameters
configure({
  withReGeocode: true,  // Return address info
  mode: 0,              // High accuracy mode
  interval: 2000,       // Update every 2 seconds
});
```

> ⚠️ **Important**: `configure` must be called after `initSDK`, otherwise configuration may not take effect.

### Q: Are there differences between Android and iOS initialization?

**A:** The initialization process is the same, but there are differences:

**Android:**
- Need to configure permissions in `AndroidManifest.xml`
- Support more location configuration options

**iOS:**
- Need to configure permission descriptions in `Info.plist`
- Support background location and heading updates

For detailed configuration, see [AMap Official Documentation](https://lbs.amap.com/).

## Best Practices

1. **Always Handle Permissions**:
   ```tsx
   // ✅ Good practice
   const status = await checkLocationPermission();
   if (!status.granted) {
     await requestLocationPermission();
   }
   
   // ❌ Bad practice
   await getCurrentLocation(); // May fail due to no permission
   ```

2. **Provide Loading State**:
   ```tsx
   if (!initialPosition) {
     return <LoadingScreen />;
   }
   ```

3. **Error Handling**:
   ```tsx
   try {
     const location = await getCurrentLocation();
   } catch (error) {
     console.error('Get location failed:', error);
     // Use default location
   }
   ```

4. **Avoid Repeated Initialization**:
   ```tsx
   useEffect(() => {
     initSDK({ ... });
   }, []); // Empty dependency array, initialize only once
   ```

## Related Documentation

- [API Documentation](./API.en.md) - Complete API reference
- [Usage Examples](./EXAMPLES.en.md) - Detailed code examples
- [README](../README.md) - Quick start guide