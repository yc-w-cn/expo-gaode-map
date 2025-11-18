# 项目架构文档

[English](./ARCHITECTURE.en.md) | 简体中文

本文档详细说明了 expo-gaode-map 项目的代码结构和各个文件的职责。

## 目录结构概览

```
expo-gaode-map/
├── src/                    # TypeScript 源代码
├── ios/                    # iOS 原生代码
├── android/                # Android 原生代码
├── docs/                   # 文档
└── example/                # 示例应用
```

---

## iOS 代码结构

```
ios/
├── ExpoGaodeMapModule.swift          # Expo 模块定义
├── ExpoGaodeMapView.swift            # 地图视图组件
├── ExpoGaodeMap.podspec              # CocoaPods 配置
├── managers/                         # 管理器类
│   ├── CameraManager.swift           # 相机控制管理器
│   ├── UIManager.swift               # UI 和手势管理器
│   └── OverlayManager.swift          # 覆盖物管理器
├── modules/                          # 功能模块
│   ├── LocationManager.swift         # 定位管理器
│   └── ColorParser.swift             # 颜色解析工具
├── utils/                            # 工具类
│   └── PermissionManager.swift       # 权限管理器
└── overlays/                         # 覆盖物视图
    ├── CircleView.swift              # 圆形覆盖物
    ├── MarkerView.swift              # 标记点
    ├── PolylineView.swift            # 折线
    ├── PolygonView.swift             # 多边形
    ├── HeatMapView.swift             # 热力图
    ├── MultiPointView.swift          # 海量点
    └── ClusterView.swift             # 点聚合
```

### iOS 文件说明

#### 核心文件

- **ExpoGaodeMapModule.swift**
  - Expo 模块的主入口
  - 注册地图视图和覆盖物视图
  - 定义 SDK 初始化方法
  - 定义定位相关方法
  - 管理定位监听器生命周期

- **ExpoGaodeMapView.swift**
  - 地图视图的主要实现
  - 管理地图属性(类型、相机位置等)
  - 处理地图事件(点击、长按等)
  - 协调各个管理器
  - 管理子视图(覆盖物)

- **ExpoGaodeMap.podspec**
  - CocoaPods 依赖配置
  - 定义 iOS SDK 版本要求
  - 指定高德地图和定位 SDK 依赖

#### 管理器类 (managers/)

- **CameraManager.swift**
  - 相机位置控制
  - 缩放级别管理
  - 地图中心点设置
  - 倾斜和旋转控制
  - 屏幕坐标与地理坐标转换

- **UIManager.swift**
  - 地图类型设置(标准/卫星/夜间/导航)
  - UI 控件显示(缩放、指南针、比例尺)
  - 手势控制(缩放、滚动、旋转、倾斜)
  - 用户位置显示和样式
  - 图层显示(交通、建筑、室内地图)

- **OverlayManager.swift**
  - 圆形覆盖物管理
  - 标记点管理
  - 折线管理(支持纹理)
  - 多边形管理
  - 覆盖物渲染器
  - 纹理图片加载

#### 功能模块 (modules/)

- **LocationManager.swift**
  - 连续定位和单次定位
  - 定位配置(精度、间隔、模式)
  - 逆地理编码
  - 方向传感器
  - 定位结果格式化

- **ColorParser.swift**
  - 颜色值解析
  - 支持多种颜色格式

#### 工具类 (utils/)

- **PermissionManager.swift**
  - 位置权限请求
  - 权限状态查询
  - 权限变化监听

#### 覆盖物视图 (overlays/)

- **CircleView.swift**
  - 圆形覆盖物视图实现
  - 支持填充色、边框色、边框宽度

- **MarkerView.swift**
  - 标记点视图实现
  - 支持标题、描述、拖拽

- **PolylineView.swift**
  - 折线视图实现
  - 支持线宽、颜色、纹理

- **PolygonView.swift**
  - 多边形视图实现
  - 支持填充色、边框色、边框宽度

- **HeatMapView.swift**
  - 热力图视图实现
  - 支持半径、透明度配置

- **MultiPointView.swift**
  - 海量点视图实现
  - 高性能点位渲染

- **ClusterView.swift**
  - 点聚合视图实现
  - 自动聚合邻近点位

---

## Android 代码结构

```
android/
└── src/main/java/expo/modules/gaodemap/
    ├── ExpoGaodeMapModule.kt         # Expo 模块定义
    ├── ExpoGaodeMapView.kt           # 地图视图组件
    ├── managers/                     # 管理器类
    │   ├── CameraManager.kt          # 相机控制管理器
    │   ├── UIManager.kt              # UI 和手势管理器
    │   └── OverlayManager.kt         # 覆盖物管理器
    ├── modules/                      # 功能模块
    │   ├── SDKInitializer.kt         # SDK 初始化
    │   └── LocationManager.kt        # 定位管理器
    ├── utils/                        # 工具类
    │   └── ColorParser.kt            # 颜色解析工具
    └── overlays/                     # 覆盖物视图
        ├── CircleView.kt             # 圆形覆盖物
        ├── MarkerView.kt             # 标记点
        ├── PolylineView.kt           # 折线
        ├── PolygonView.kt            # 多边形
        ├── HeatMapView.kt            # 热力图
        ├── MultiPointView.kt         # 海量点
        └── ClusterView.kt            # 点聚合
```

### Android 文件说明

#### 核心文件

- **ExpoGaodeMapModule.kt**
  - Expo 模块的主入口
  - 注册地图视图和覆盖物视图
  - 定义 SDK 初始化方法
  - 定义定位相关方法
  - 定义权限管理方法
  - 管理定位监听器生命周期

- **ExpoGaodeMapView.kt**
  - 地图视图的主要实现
  - 管理地图属性(类型、相机位置等)
  - 处理地图事件(点击、长按、加载)
  - 协调各个管理器
  - 管理子视图(覆盖物)
  - 处理生命周期和内存管理

#### 管理器类 (managers/)

- **CameraManager.kt**
  - 相机位置控制
  - 缩放级别管理(包括最大/最小限制)
  - 地图中心点设置
  - 倾斜和旋转控制
  - 屏幕坐标与地理坐标转换
  - 动画相机移动

- **UIManager.kt**
  - 地图类型设置(标准/卫星/夜间/导航/公交)
  - UI 控件显示(缩放、指南针、比例尺)
  - 手势控制(缩放、滚动、旋转、倾斜)
  - 用户位置显示和样式
  - 自定义定位图标(支持网络图片)
  - 图层显示(交通、建筑、室内地图)

- **OverlayManager.kt**
  - 圆形覆盖物管理
  - 标记点管理
  - 折线管理(支持纹理贴图)
  - 多边形管理
  - 覆盖物属性更新
  - 纹理图片加载(支持网络和本地)

#### 功能模块 (modules/)

- **SDKInitializer.kt**
  - SDK 初始化
  - 隐私合规设置
  - API Key 配置
  - 版本信息获取

- **LocationManager.kt**
  - 连续定位和单次定位
  - 定位配置(精度、间隔、模式)
  - 逆地理编码
  - 坐标转换
  - 定位结果格式化
  - 资源清理

#### 工具类 (utils/)

- **ColorParser.kt**
  - 颜色值解析
  - 支持多种颜色格式(十六进制、整数)
  - 透明度处理

#### 覆盖物视图 (overlays/)

- **CircleView.kt**
  - 圆形覆盖物视图实现
  - 支持填充色、边框色、边框宽度
  - 属性动态更新

- **MarkerView.kt**
  - 标记点视图实现
  - 支持标题、描述、拖拽
  - 自定义图标

- **PolylineView.kt**
  - 折线视图实现
  - 支持线宽、颜色
  - 纹理贴图支持

- **PolygonView.kt**
  - 多边形视图实现
  - 支持填充色、边框色、边框宽度
  - Z-Index 层级控制

- **HeatMapView.kt**
  - 热力图视图实现
  - 支持半径、透明度配置
  - 高性能热力渲染

- **MultiPointView.kt**
  - 海量点视图实现
  - 高性能点位渲染
  - 自定义点样式

- **ClusterView.kt**
  - 点聚合视图实现
  - 自动聚合邻近点位
  - 可配置聚合半径和最小聚合数量

---

## TypeScript 代码结构

```
src/
├── index.ts                          # 主导出文件
├── ExpoGaodeMapModule.ts             # 原生模块导入
├── ExpoGaodeMapView.tsx              # 地图视图组件
├── ExpoGaodeMap.types.ts             # 类型定义导出
├── components/                       # React 组件
│   └── overlays/                     # 覆盖物组件
│       ├── index.ts                  # 覆盖物导出
│       ├── Circle.tsx                # 圆形组件
│       ├── Marker.tsx                # 标记点组件
│       ├── Polyline.tsx              # 折线组件
│       ├── Polygon.tsx               # 多边形组件
│       ├── HeatMap.tsx               # 热力图组件
│       ├── MultiPoint.tsx            # 海量点组件
│       └── Cluster.tsx               # 点聚合组件
├── modules/                          # 功能模块
│   ├── AMapSDK.ts                    # SDK 模块
│   ├── AMapLocation.ts               # 定位模块
│   └── AMapView.ts                   # 地图视图模块(已废弃)
└── types/                            # TypeScript 类型定义
    ├── index.ts                      # 类型导出
    ├── common.types.ts               # 通用类型
    ├── map-view.types.ts             # 地图视图类型
    ├── location.types.ts             # 定位类型
    ├── overlays.types.ts             # 覆盖物类型
    └── sdk.types.ts                  # SDK 类型
```

### TypeScript 文件说明

#### 核心文件

- **index.ts**
  - 主导出文件
  - 导出所有公共 API

- **ExpoGaodeMapModule.ts**
  - 原生模块导入
  - 事件类型定义

- **ExpoGaodeMapView.tsx**
  - 地图视图 React 组件
  - 封装原生视图
  - 提供命令式 API(ref)

- **ExpoGaodeMap.types.ts**
  - 重新导出所有类型
  - 提供便捷的类型导入

#### 组件 (components/)

覆盖物组件提供声明式 API,作为 MapView 的子组件使用。

#### 模块 (modules/)

- **AMapSDK.ts**
  - SDK 初始化
  - 版本获取

- **AMapLocation.ts**
  - 定位配置
  - 定位监听
  - 位置获取

#### 类型 (types/)

定义了所有 TypeScript 类型,包括:
- 地图配置
- 相机位置
- 覆盖物属性
- 定位结果
- 事件回调

---

## 架构设计原则

### 1. 职责分离

- **Module**: 负责模块定义和方法注册
- **View**: 负责视图创建和属性管理
- **Manager**: 负责具体功能实现
- **Overlay**: 负责覆盖物渲染

### 2. 跨平台一致性

- iOS 和 Android 提供相同的 API
- TypeScript 层统一封装
- 差异在原生层处理

### 3. 内存管理

- 使用弱引用避免循环引用
- 及时清理监听器和资源
- 主线程操作使用 Handler/DispatchQueue

### 4. 错误处理

- Promise 处理异步操作
- 统一的错误码和消息
- 详细的错误日志

### 5. 性能优化

- 主线程调度 UI 操作
- 后台线程加载图片
- 覆盖物按需渲染

---

## 开发指南

### 添加新功能

1. 在原生层实现功能(iOS 和 Android)
2. 在 Module 中注册方法
3. 在 TypeScript 层封装 API
4. 添加类型定义
5. 更新文档

### 调试技巧

- 使用日志查看调用流程
- 检查主线程操作
- 验证内存泄露
- 测试边界情况

### 代码规范

- 使用详细的中文注释
- 遵循平台命名规范
- 保持代码整洁
- 编写单元测试

---

## 相关文档

- [README.md](../README.md) - 快速开始和基本使用
- [API.md](./API.md) - 完整 API 文档
- [EXAMPLES.md](./EXAMPLES.md) - 示例代码
- [INITIALIZATION.md](./INITIALIZATION.md) - 初始化指南