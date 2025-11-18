# Project Architecture Documentation

English | [简体中文](./ARCHITECTURE.md)

This document details the code structure and file responsibilities of the expo-gaode-map project.

## Directory Structure Overview

```
expo-gaode-map/
├── src/                    # TypeScript source code
├── ios/                    # iOS native code
├── android/                # Android native code
├── docs/                   # Documentation
└── example/                # Example application
```

---

## iOS Code Structure

```
ios/
├── ExpoGaodeMapModule.swift          # Expo module definition
├── ExpoGaodeMapView.swift            # Map view component
├── ExpoGaodeMap.podspec              # CocoaPods configuration
├── managers/                         # Manager classes
│   ├── CameraManager.swift           # Camera control manager
│   ├── UIManager.swift               # UI and gesture manager
│   └── OverlayManager.swift          # Overlay manager
├── modules/                          # Feature modules
│   ├── LocationManager.swift         # Location manager
│   └── ColorParser.swift             # Color parser utility
├── utils/                            # Utility classes
│   └── PermissionManager.swift       # Permission manager
└── overlays/                         # Overlay views
    ├── CircleView.swift              # Circle overlay
    ├── MarkerView.swift              # Marker
    ├── PolylineView.swift            # Polyline
    ├── PolygonView.swift             # Polygon
    ├── HeatMapView.swift             # Heat map
    ├── MultiPointView.swift          # Multi-point
    └── ClusterView.swift             # Cluster
```

### iOS File Descriptions

#### Core Files

- **ExpoGaodeMapModule.swift**
  - Expo module entry point
  - Register map view and overlay views
  - Define SDK initialization methods
  - Define location-related methods
  - Manage location listener lifecycle

- **ExpoGaodeMapView.swift**
  - Main map view implementation
  - Manage map properties (type, camera position, etc.)
  - Handle map events (press, long press, etc.)
  - Coordinate managers
  - Manage child views (overlays)

- **ExpoGaodeMap.podspec**
  - CocoaPods dependency configuration
  - Define iOS SDK version requirements
  - Specify AMap SDK dependencies

#### Manager Classes (managers/)

- **CameraManager.swift**
  - Camera position control
  - Zoom level management
  - Map center point setting
  - Tilt and rotation control
  - Screen/geographic coordinate conversion

- **UIManager.swift**
  - Map type setting (normal/satellite/night/navigation)
  - UI control display (zoom, compass, scale)
  - Gesture control (zoom, scroll, rotate, tilt)
  - User location display and styling
  - Layer display (traffic, buildings, indoor maps)

- **OverlayManager.swift**
  - Circle overlay management
  - Marker management
  - Polyline management (texture support)
  - Polygon management
  - Overlay renderers
  - Texture image loading

#### Feature Modules (modules/)

- **LocationManager.swift**
  - Continuous and single location
  - Location configuration (accuracy, interval, mode)
  - Reverse geocoding
  - Heading sensor
  - Location result formatting

- **ColorParser.swift**
  - Color value parsing
  - Support multiple color formats

#### Utility Classes (utils/)

- **PermissionManager.swift**
  - Location permission request
  - Permission status query
  - Permission change listener

#### Overlay Views (overlays/)

- **CircleView.swift**
  - Circle overlay view implementation
  - Support fill color, stroke color, stroke width

- **MarkerView.swift**
  - Marker view implementation
  - Support title, description, draggable

- **PolylineView.swift**
  - Polyline view implementation
  - Support line width, color, texture

- **PolygonView.swift**
  - Polygon view implementation
  - Support fill color, stroke color, stroke width

- **HeatMapView.swift**
  - Heat map view implementation
  - Support radius, opacity configuration

- **MultiPointView.swift**
  - Multi-point view implementation
  - High-performance point rendering

- **ClusterView.swift**
  - Cluster view implementation
  - Auto-cluster nearby points

---

## Android Code Structure

```
android/
└── src/main/java/expo/modules/gaodemap/
    ├── ExpoGaodeMapModule.kt         # Expo module definition
    ├── ExpoGaodeMapView.kt           # Map view component
    ├── managers/                     # Manager classes
    │   ├── CameraManager.kt          # Camera control manager
    │   ├── UIManager.kt              # UI and gesture manager
    │   └── OverlayManager.kt         # Overlay manager
    ├── modules/                      # Feature modules
    │   ├── SDKInitializer.kt         # SDK initialization
    │   └── LocationManager.kt        # Location manager
    ├── utils/                        # Utility classes
    │   └── ColorParser.kt            # Color parser utility
    └── overlays/                     # Overlay views
        ├── CircleView.kt             # Circle overlay
        ├── MarkerView.kt             # Marker
        ├── PolylineView.kt           # Polyline
        ├── PolygonView.kt            # Polygon
        ├── HeatMapView.kt            # Heat map
        ├── MultiPointView.kt         # Multi-point
        └── ClusterView.kt            # Cluster
```

### Android File Descriptions

#### Core Files

- **ExpoGaodeMapModule.kt**
  - Expo module entry point
  - Register map view and overlay views
  - Define SDK initialization methods
  - Define location-related methods
  - Define permission management methods
  - Manage location listener lifecycle

- **ExpoGaodeMapView.kt**
  - Main map view implementation
  - Manage map properties (type, camera position, etc.)
  - Handle map events (press, long press, load)
  - Coordinate managers
  - Manage child views (overlays)
  - Handle lifecycle and memory management

#### Manager Classes (managers/)

- **CameraManager.kt**
  - Camera position control
  - Zoom level management (including max/min limits)
  - Map center point setting
  - Tilt and rotation control
  - Screen/geographic coordinate conversion
  - Animated camera movement

- **UIManager.kt**
  - Map type setting (normal/satellite/night/navigation/bus)
  - UI control display (zoom, compass, scale)
  - Gesture control (zoom, scroll, rotate, tilt)
  - User location display and styling
  - Custom location icon (network image support)
  - Layer display (traffic, buildings, indoor maps)

- **OverlayManager.kt**
  - Circle overlay management
  - Marker management
  - Polyline management (texture support)
  - Polygon management
  - Overlay property updates
  - Texture image loading (network and local)

#### Feature Modules (modules/)

- **SDKInitializer.kt**
  - SDK initialization
  - Privacy compliance settings
  - API Key configuration
  - Version info retrieval

- **LocationManager.kt**
  - Continuous and single location
  - Location configuration (accuracy, interval, mode)
  - Reverse geocoding
  - Coordinate conversion
  - Location result formatting
  - Resource cleanup

#### Utility Classes (utils/)

- **ColorParser.kt**
  - Color value parsing
  - Support multiple color formats (hex, integer)
  - Transparency handling

#### Overlay Views (overlays/)

- **CircleView.kt**
  - Circle overlay view implementation
  - Support fill color, stroke color, stroke width
  - Dynamic property updates

- **MarkerView.kt**
  - Marker view implementation
  - Support title, description, draggable
  - Custom icon

- **PolylineView.kt**
  - Polyline view implementation
  - Support line width, color
  - Texture support

- **PolygonView.kt**
  - Polygon view implementation
  - Support fill color, stroke color, stroke width
  - Z-Index layer control

- **HeatMapView.kt**
  - Heat map view implementation
  - Support radius, opacity configuration
  - High-performance heat rendering

- **MultiPointView.kt**
  - Multi-point view implementation
  - High-performance point rendering
  - Custom point style

- **ClusterView.kt**
  - Cluster view implementation
  - Auto-cluster nearby points
  - Configurable cluster radius and minimum count

---

## TypeScript Code Structure

```
src/
├── index.ts                          # Main export file
├── ExpoGaodeMapModule.ts             # Native module import
├── ExpoGaodeMapView.tsx              # Map view component
├── ExpoGaodeMap.types.ts             # Type definition export
├── components/                       # React components
│   └── overlays/                     # Overlay components
│       ├── index.ts                  # Overlay exports
│       ├── Circle.tsx                # Circle component
│       ├── Marker.tsx                # Marker component
│       ├── Polyline.tsx              # Polyline component
│       ├── Polygon.tsx               # Polygon component
│       ├── HeatMap.tsx               # Heat map component
│       ├── MultiPoint.tsx            # Multi-point component
│       └── Cluster.tsx               # Cluster component
├── modules/                          # Feature modules
│   ├── AMapSDK.ts                    # SDK module
│   ├── AMapLocation.ts               # Location module
│   └── AMapView.ts                   # Map view module (deprecated)
└── types/                            # TypeScript type definitions
    ├── index.ts                      # Type exports
    ├── common.types.ts               # Common types
    ├── map-view.types.ts             # Map view types
    ├── location.types.ts             # Location types
    ├── overlays.types.ts             # Overlay types
    └── sdk.types.ts                  # SDK types
```

### TypeScript File Descriptions

#### Core Files

- **index.ts**
  - Main export file
  - Export all public APIs

- **ExpoGaodeMapModule.ts**
  - Native module import
  - Event type definitions

- **ExpoGaodeMapView.tsx**
  - Map view React component
  - Wrap native view
  - Provide imperative API (ref)

- **ExpoGaodeMap.types.ts**
  - Re-export all types
  - Provide convenient type imports

#### Components (components/)

Overlay components provide declarative API, used as MapView children.

#### Modules (modules/)

- **AMapSDK.ts**
  - SDK initialization
  - Version retrieval

- **AMapLocation.ts**
  - Location configuration
  - Location listeners
  - Location retrieval

#### Types (types/)

Define all TypeScript types, including:
- Map configuration
- Camera position
- Overlay properties
- Location results
- Event callbacks

---

## Architecture Design Principles

### 1. Separation of Concerns

- **Module**: Module definition and method registration
- **View**: View creation and property management
- **Manager**: Specific feature implementation
- **Overlay**: Overlay rendering

### 2. Cross-Platform Consistency

- iOS and Android provide same API
- TypeScript layer unified encapsulation
- Differences handled in native layer

### 3. Memory Management

- Use weak references to avoid circular references
- Timely cleanup of listeners and resources
- Main thread operations use Handler/DispatchQueue

### 4. Error Handling

- Promise for async operations
- Unified error codes and messages
- Detailed error logging

### 5. Performance Optimization

- Main thread scheduling for UI operations
- Background thread for image loading
- On-demand overlay rendering

---

## Development Guide

### Adding New Features

1. Implement feature in native layer (iOS and Android)
2. Register methods in Module
3. Wrap API in TypeScript layer
4. Add type definitions
5. Update documentation

### Debugging Tips

- Use logs to view call flow
- Check main thread operations
- Verify memory leaks
- Test edge cases

### Code Standards

- Use detailed comments
- Follow platform naming conventions
- Keep code clean
- Write unit tests

---

## Related Documentation

- [README.md](../README.md) - Quick start and basic usage
- [API.md](./API.en.md) - Complete API documentation
- [EXAMPLES.md](./EXAMPLES.en.md) - Example code
- [INITIALIZATION.md](./INITIALIZATION.en.md) - Initialization guide