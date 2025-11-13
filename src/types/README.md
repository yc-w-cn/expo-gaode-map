# 高德地图 Expo Module 类型定义

本目录包含基于 Expo Modules API 重新设计的高德地图类型定义，从旧的 `requireNativeComponent` 方式迁移到新的 Expo Modules 架构。

## 文件结构

```
src/types/
├── index.ts           # 统一导出入口
├── common.types.ts    # 通用类型定义
├── map-view.types.ts  # 地图视图类型
├── location.types.ts  # 定位相关类型
├── overlays.types.ts  # 覆盖物类型（标记、折线、多边形等）
├── sdk.types.ts       # SDK 模块接口定义
└── README.md          # 本文件
```

## 主要变化

### 1. 从旧版本迁移

**旧版本方式** (基于 `requireNativeComponent`):
```typescript
import { requireNativeComponent } from 'react-native';
const AMapView = requireNativeComponent<MapViewProps>('AMapView');
```

**新版本方式** (基于 Expo Modules):
```typescript
import { requireNativeView } from 'expo-modules-core';
// 或在 Module Definition 中使用 View() 定义
```

### 2. 类型系统改进

- **模块化**: 将类型按功能分类到不同文件
- **类型安全**: 使用 TypeScript 严格模式
- **文档完善**: 每个类型都有详细的 JSDoc 注释
- **平台标注**: 使用 `@platform` 标注平台特定功能

### 3. 事件处理改进

**旧版本**:
```typescript
onPress?: (event: NativeSyntheticEvent<LatLng>) => void;
```

**新版本** (Expo Modules 标准):
```typescript
onPress?: (event: { nativeEvent: LatLng }) => void;
```

## 使用示例

### 导入类型

```typescript
// 导入通用类型
import type { LatLng, CameraPosition, MapType } from './types';

// 导入地图视图类型
import type { MapViewProps, MapViewMethods } from './types';

// 导入定位类型
import type { 
  Coordinates, 
  ReGeocode, 
  LocationOptions,
  LocationAccuracy,
  LocationMode 
} from './types';

// 导入覆盖物类型
import type { 
  MarkerProps, 
  PolylineProps, 
  PolygonProps 
} from './types';
```

### 类型使用示例

#### 1. 地图视图

```typescript
import type { MapViewProps } from './types';

const mapConfig: MapViewProps = {
  mapType: MapType.Standard,
  initialCameraPosition: {
    target: { latitude: 39.9, longitude: 116.4 },
    zoom: 10,
  },
  myLocationEnabled: true,
  compassEnabled: true,
  onPress: (event) => {
    console.log('点击位置:', event.nativeEvent);
  },
};
```

#### 2. 定位配置

```typescript
import type { LocationOptions } from './types';
import { LocationMode, LocationAccuracy } from './types';

const locationConfig: LocationOptions = {
  withReGeocode: true,
  mode: LocationMode.HighAccuracy,
  accuracy: LocationAccuracy.HundredMeters,
  interval: 2000,
  geoLanguage: 'ZH',
};
```

#### 3. 标记点

```typescript
import type { MarkerProps } from './types';

const markerConfig: MarkerProps = {
  position: { latitude: 39.9, longitude: 116.4 },
  title: '北京',
  draggable: true,
  onPress: () => console.log('标记被点击'),
  onDragEnd: (event) => {
    console.log('拖拽结束位置:', event.nativeEvent);
  },
};
```

## 与旧代码的对应关系

| 旧文件 | 新类型文件 | 说明 |
|--------|-----------|------|
| `types.ts` | `common.types.ts` | 基础类型定义 |
| `map-view.tsx` | `map-view.types.ts` | 地图视图类型 |
| `geolocation/index.d.ts` | `location.types.ts` | 定位类型 |
| `location/index.d.ts` | `location.types.ts` | 定位类型（合并） |
| `marker.tsx` | `overlays.types.ts` | 标记类型 |
| `polyline.tsx` | `overlays.types.ts` | 折线类型 |
| `polygon.tsx` | `overlays.types.ts` | 多边形类型 |
| `circle.tsx` | `overlays.types.ts` | 圆形类型 |
| `heat-map.tsx` | `overlays.types.ts` | 热力图类型 |
| `multi-point.tsx` | `overlays.types.ts` | 海量点类型 |
| `cluster/index.tsx` | `overlays.types.ts` | 聚合图层类型 |
| `sdk.ts` | `sdk.types.ts` | SDK 模块类型 |

## 下一步工作

1. **实现原生模块**
   - Android: 在 `ExpoGaodeMapModule.kt` 中实现模块定义
   - iOS: 在 `ExpoGaodeMapModule.swift` 中实现模块定义

2. **实现视图组件**
   - Android: 实现各种覆盖物的原生视图
   - iOS: 实现各种覆盖物的原生视图

3. **创建 React 组件**
   - 基于类型定义创建对应的 React 组件
   - 使用 `requireNativeView` 或 `requireNativeModule`

4. **编写单元测试**
   - 测试类型定义的正确性
   - 测试组件的功能完整性

## 参考文档

- [Expo Modules API 文档](https://docs.expo.dev/modules/module-api/)
- [高德地图 Android SDK](https://lbs.amap.com/api/android-sdk/summary)
- [高德地图 iOS SDK](https://lbs.amap.com/api/ios-sdk/summary)
- [TypeScript 类型系统](https://www.typescriptlang.org/docs/handbook/2/types-from-types.html)

## 注意事项

1. **类型导出**: 使用 `export type` 导出类型，避免运行时开销
2. **枚举使用**: 对于固定值集合，优先使用 `enum`
3. **可选属性**: 合理使用 `?` 标记可选属性
4. **平台差异**: 使用 `@platform` 注释标注平台特定功能
5. **向后兼容**: 新类型应尽可能保持与旧类型的兼容性

## 版本历史

- **v2.0.0** (2025-11-13): 基于 Expo Modules API 重新设计类型系统
- **v1.x**: 基于 `requireNativeComponent` 的旧版本实现
