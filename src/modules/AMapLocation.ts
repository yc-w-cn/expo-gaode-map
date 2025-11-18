//高德地图定位模块

import { EventSubscription } from 'expo-modules-core';
import ExpoGaodeMapModule from '../ExpoGaodeMapModule';
import type {
  Coordinates,
  ReGeocode,
  LocationOptions,
  LocationListener,
  LatLng,
  CoordinateType,
} from '../types';


/**
 * 配置方法映射表
 * @type {Record<keyof LocationOptions, string>}
 * 
 */
const CONFIG_MAP: Record<keyof LocationOptions, string> = {
  withReGeocode: 'setLocatingWithReGeocode',
  accuracy: 'setDesiredAccuracy',
  mode: 'setLocationMode',
  onceLocation: 'setOnceLocation',
  interval: 'setInterval',
  timeout: 'setLocationTimeout',
  reGeocodeTimeout: 'setReGeocodeTimeout',
  distanceFilter: 'setDistanceFilter',
  sensorEnable: 'setSensorEnable',
  wifiScan: 'setWifiScan',
  gpsFirst: 'setGpsFirst',
  onceLocationLatest: 'setOnceLocationLatest',
  geoLanguage: 'setGeoLanguage',
  allowsBackgroundLocationUpdates: 'setAllowsBackgroundLocationUpdates',
  pausesLocationUpdatesAutomatically: 'setPausesLocationUpdatesAutomatically',
  locationCacheEnable: 'setLocationCacheEnable',
  httpTimeout: 'setHttpTimeOut',
  protocol: 'setLocationProtocol',
};

/**
 * 配置高德地图定位选项
 * @param {LocationOptions} options - 定位配置选项对象
 * @throws {Error} 当传入的配置方法不存在或不可调用时抛出错误
 */
export function configure(options: LocationOptions): void {
  Object.entries(options).forEach(([key, value]) => {
    if (value !== undefined) {
      const methodName = CONFIG_MAP[key as keyof LocationOptions];
      const method = ExpoGaodeMapModule[methodName as keyof typeof ExpoGaodeMapModule];
      if (typeof method === 'function') {
        (method as any).call(ExpoGaodeMapModule, value);
      }
    }
  });
}


/**
 * 启动高德地图模块,开始连续定位
 * @throws 如果模块未初始化或启动失败时抛出异常
 */
export function start(): void {
  ExpoGaodeMapModule.start?.();
}


/**
 * 停止高德地图相关功能,停止定位
 * @returns {void} 无返回值
 */
export function stop(): void {
  ExpoGaodeMapModule.stop?.();
}


/**
 * 检查高德地图模块是否已启动,是否正在定位
 * @returns {Promise<boolean>} 返回一个Promise，解析为布尔值表示模块是否已启动
 */
export async function isStarted(): Promise<boolean> {
  return ExpoGaodeMapModule.isStarted?.() || Promise.resolve(false);
}


/**
 * 获取设备当前位置信息,单次定位
 * @returns {Promise<Coordinates | ReGeocode>} 返回包含坐标或逆地理编码信息的Promise
 * @throws 如果定位服务不可用或权限被拒绝时抛出错误
 */
export async function getCurrentLocation(): Promise<Coordinates | ReGeocode> {
  return ExpoGaodeMapModule.getCurrentLocation?.();
}


/**
 * 添加位置更新监听器
 * @param {LocationListener} listener - 位置更新时的回调函数
 * @returns {EventSubscription} 事件订阅对象，包含移除监听器的方法
 * @throws 如果底层模块不可用，返回一个空操作的订阅对象
 */
export function addLocationListener(listener: LocationListener): EventSubscription {
  return ExpoGaodeMapModule.addListener?.('onLocationUpdate', listener) || {
    remove: () => {},
  } as EventSubscription;
}


/**
 * 将坐标点转换为指定坐标系下的坐标
 * @param {LatLng} coordinate - 需要转换的原始坐标点
 * @param {CoordinateType} type - 目标坐标系类型
 * @returns {Promise<LatLng>} 转换后的坐标点Promise
 * @throws 如果底层模块不可用，则返回原始坐标
 */
export async function coordinateConvert(
  coordinate: LatLng,
  type: CoordinateType
): Promise<LatLng> {
  return ExpoGaodeMapModule.coordinateConvert?.(coordinate, type) || Promise.resolve(coordinate);
}


/**
 * 开始更新设备方向（罗盘朝向）
 * 调用原生模块方法启动方向更新功能
 * @throws 如果原生模块未实现此方法会抛出异常
 * @platform ios
 */
export function startUpdatingHeading(): void {
  ExpoGaodeMapModule.startUpdatingHeading?.();
}


/**
 * 停止更新设备方向（罗盘朝向）
 * 调用原生模块方法停止监听设备方向变化
 * @throws 如果原生模块未实现此方法会抛出异常
 * @platform ios
 */
export function stopUpdatingHeading(): void {
  ExpoGaodeMapModule.stopUpdatingHeading?.();
}

/**
 * 设置高德地图的API密钥
 * @param {string} key - 高德地图的API密钥
 * @returns {void}
 */
export function setApiKey(key: string): void {
  ExpoGaodeMapModule.setApiKey?.(key);
}

export default {
  configure,
  start,
  stop,
  isStarted,
  getCurrentLocation,
  addLocationListener,
  coordinateConvert,
  startUpdatingHeading,
  stopUpdatingHeading,
  setApiKey,
};
