# followUserLocation 属性使用说明

## 📖 概述

`followUserLocation` 是地图组件的一个可选属性，用于控制地图是否自动跟随用户位置移动。

## 🎯 使用场景

### 1. **浏览模式**（默认 - `false`）
- ✅ 显示用户定位点
- ✅ 用户可以自由滑动地图
- ✅ 地图**不会**自动移动

**适用场景**：
- 地图浏览
- 查看周边信息
- 选择地点

```tsx
<MapView
  myLocationEnabled={true}
  followUserLocation={false}  // 默认值，可以省略
  style={{ flex: 1 }}
/>
```

### 2. **导航模式**（`true`）
- ✅ 显示用户定位点
- ✅ 地图会自动跟随用户位置移动
- ⚠️ 用户滑动后，定位更新时会重新跟随

**适用场景**：
- 实时导航
- 运动轨迹记录
- 位置追踪

```tsx
<MapView
  myLocationEnabled={true}
  followUserLocation={true}  // 开启跟随
  style={{ flex: 1 }}
/>
```

## 💡 完整示例

### 可切换跟随模式

```tsx
import React, { useState } from 'react';
import { View, Button, StyleSheet } from 'react-native';
import { MapView } from 'expo-gaode-map';

export default function App() {
  const [followMode, setFollowMode] = useState(false);

  return (
    <View style={styles.container}>
      <MapView
        style={styles.map}
        myLocationEnabled={true}
        followUserLocation={followMode}
        initialCameraPosition={{
          target: { latitude: 39.9, longitude: 116.4 },
          zoom: 15,
        }}
      />
      
      <View style={styles.controls}>
        <Button
          title={followMode ? '浏览模式' : '跟随模式'}
          onPress={() => setFollowMode(!followMode)}
        />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  map: {
    flex: 1,
  },
  controls: {
    position: 'absolute',
    bottom: 20,
    left: 20,
    right: 20,
  },
});
```

## 📋 属性详情

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `followUserLocation` | `boolean` | `false` | 是否跟随用户位置 |
| `myLocationEnabled` | `boolean` | `false` | 是否显示定位点（必须同时开启） |

## 🔧 实现原理

### Android 端定位模式

| `followUserLocation` | 高德地图模式 | 行为 |
|---------------------|------------|------|
| `false` | `LOCATION_TYPE_SHOW` | 只显示定位点 |
| `true` | `LOCATION_TYPE_FOLLOW` | 跟随用户位置 |

## ⚠️ 注意事项

1. **必须先开启定位**
   ```tsx
   // ❌ 错误 - 没有开启定位
   <MapView followUserLocation={true} />
   
   // ✅ 正确 - 同时开启定位
   <MapView 
     myLocationEnabled={true}
     followUserLocation={true}
   />
   ```

2. **权限要求**
   - 需要定位权限（`ACCESS_FINE_LOCATION`）
   - 需要在 `app.json` 中配置

3. **默认行为已优化**
   - 不设置 `followUserLocation` 时，默认为 `false`
   - 不会再出现自动跟随的问题

## 🎨 UI 建议

建议提供一个按钮让用户切换模式：

```tsx
<TouchableOpacity
  style={styles.locationButton}
  onPress={() => setFollowMode(!followMode)}
>
  <Icon 
    name={followMode ? 'location-arrow' : 'location'} 
    size={24} 
  />
</TouchableOpacity>
```

## 🐛 常见问题

### Q: 为什么地图一直自动移动？
A: 因为 `followUserLocation` 被设置为 `true` 或使用了旧版本。解决方法：
```tsx
// 方案1：不设置（默认 false）
<MapView myLocationEnabled={true} />

// 方案2：显式设置为 false
<MapView 
  myLocationEnabled={true}
  followUserLocation={false}
/>
```

### Q: 如何只在首次定位时移动地图？
A: 使用 `onLoad` 事件：
```tsx
const [hasInitialized, setHasInitialized] = useState(false);

<MapView
  myLocationEnabled={true}
  followUserLocation={false}
  onLoad={async () => {
    if (!hasInitialized) {
      const position = await getCurrentLocation();
      mapRef.current?.setCenter(position, true);
      setHasInitialized(true);
    }
  }}
/>
```

## 📚 相关文档

- [MapView API 文档](./MapView.md)
- [定位功能文档](./Location.md)
- [高德地图官方文档](https://lbs.amap.com/api/android-sdk/guide/map/mylocation)
