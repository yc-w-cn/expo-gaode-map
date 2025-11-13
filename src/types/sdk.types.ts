/**
 * 高德地图 SDK 模块类型定义
 * 基于 Expo Modules API
 */

import type { LatLng } from './common.types';
import type { 
  Coordinates, 
  ReGeocode, 
  LocationOptions, 
  LocationListener,
  CoordinateType 
} from './location.types';

/**
 * SDK 初始化配置
 */
export interface SDKConfig {
  /**
   * iOS API Key
   */
  iosKey?: string;

  /**
   * Android API Key
   */
  androidKey?: string;
}

/**
 * 高德地图 SDK 模块接口
 */
export interface AMapSDKModule {
  /**
   * 初始化 SDK
   * @param config SDK配置
   */
  initSDK(config: SDKConfig): void;

  /**
   * 获取 SDK 版本号
   */
  getVersion(): Promise<string>;

  /**
   * 设置 API Key（单平台）
   * @param key API密钥
   */
  setApiKey(key: string): void;
}

/**
 * 高德定位模块接口
 */
export interface AMapLocationModule {
  /**
   * 配置定位选项
   * @param options 定位配置选项
   */
  configure(options: LocationOptions): void;

  /**
   * 开始连续定位
   */
  start(): void;

  /**
   * 停止定位
   */
  stop(): void;

  /**
   * 是否正在定位
   */
  isStarted(): Promise<boolean>;

  /**
   * 获取当前位置（单次定位）
   */
  getCurrentLocation(): Promise<Coordinates | ReGeocode>;

  /**
   * 添加定位监听器
   * @param listener 定位回调函数
   * @returns 订阅对象，用于取消监听
   */
  addLocationListener(listener: LocationListener): { remove: () => void };

  /**
   * 坐标转换
   * @param coordinate 待转换的坐标
   * @param type 坐标系类型
   */
  coordinateConvert(coordinate: LatLng, type: CoordinateType): Promise<LatLng>;

  /**
   * 开始获取设备朝向
   * @platform ios
   */
  startUpdatingHeading(): void;

  /**
   * 停止获取设备朝向
   * @platform ios
   */
  stopUpdatingHeading(): void;
}

/**
 * 模块事件类型
 */
export interface ModuleEvents {
  /**
   * 定位更新事件
   */
  onLocationUpdate: (location: Coordinates | ReGeocode) => void;

  /**
   * 定位错误事件
   */
  onLocationError: (error: { code: number; message: string }) => void;

  /**
   * 朝向更新事件
   * @platform ios
   */
  onHeadingUpdate: (heading: { magneticHeading: number; trueHeading: number }) => void;
}
