/*
 * @Author       : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @Date         : 2025-11-13 14:42:10
 * @LastEditors  : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @LastEditTime : 2025-11-13 14:42:15
 * @FilePath     : /expo-gaode-map/src/modules/AMapLocation.ts
 * @Description  : 高德地图定位模块
 * 
 * Copyright (c) 2025 by 尚博信_王强, All Rights Reserved. 
 */

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
 * 配置定位选项
 */
export function configure(options: LocationOptions): void {
  if (options.withReGeocode !== undefined) {
    ExpoGaodeMapModule.setLocatingWithReGeocode?.(options.withReGeocode);
  }
  if (options.accuracy !== undefined) {
    ExpoGaodeMapModule.setDesiredAccuracy?.(options.accuracy);
  }
  if (options.mode !== undefined) {
    ExpoGaodeMapModule.setLocationMode?.(options.mode);
  }
  if (options.onceLocation !== undefined) {
    ExpoGaodeMapModule.setOnceLocation?.(options.onceLocation);
  }
  if (options.interval !== undefined) {
    ExpoGaodeMapModule.setInterval?.(options.interval);
  }
  if (options.timeout !== undefined) {
    ExpoGaodeMapModule.setLocationTimeout?.(options.timeout);
  }
  if (options.reGeocodeTimeout !== undefined) {
    ExpoGaodeMapModule.setReGeocodeTimeout?.(options.reGeocodeTimeout);
  }
  if (options.distanceFilter !== undefined) {
    ExpoGaodeMapModule.setDistanceFilter?.(options.distanceFilter);
  }
  if (options.sensorEnable !== undefined) {
    ExpoGaodeMapModule.setSensorEnable?.(options.sensorEnable);
  }
  if (options.wifiScan !== undefined) {
    ExpoGaodeMapModule.setWifiScan?.(options.wifiScan);
  }
  if (options.gpsFirst !== undefined) {
    ExpoGaodeMapModule.setGpsFirst?.(options.gpsFirst);
  }
  if (options.onceLocationLatest !== undefined) {
    ExpoGaodeMapModule.setOnceLocationLatest?.(options.onceLocationLatest);
  }
  if (options.geoLanguage !== undefined) {
    ExpoGaodeMapModule.setGeoLanguage?.(options.geoLanguage);
  }
  if (options.allowsBackgroundLocationUpdates !== undefined) {
    ExpoGaodeMapModule.setAllowsBackgroundLocationUpdates?.(options.allowsBackgroundLocationUpdates);
  }
  if (options.pausesLocationUpdatesAutomatically !== undefined) {
    ExpoGaodeMapModule.setPausesLocationUpdatesAutomatically?.(options.pausesLocationUpdatesAutomatically);
  }
  if (options.locationCacheEnable !== undefined) {
    ExpoGaodeMapModule.setLocationCacheEnable?.(options.locationCacheEnable);
  }
  if (options.httpTimeout !== undefined) {
    ExpoGaodeMapModule.setHttpTimeOut?.(options.httpTimeout);
  }
  if (options.protocol !== undefined) {
    ExpoGaodeMapModule.setLocationProtocol?.(options.protocol);
  }
}

/**
 * 开始连续定位
 */
export function start(): void {
  ExpoGaodeMapModule.start?.();
}

/**
 * 停止定位
 */
export function stop(): void {
  ExpoGaodeMapModule.stop?.();
}

/**
 * 是否正在定位
 */
export async function isStarted(): Promise<boolean> {
  return ExpoGaodeMapModule.isStarted?.() || Promise.resolve(false);
}

/**
 * 获取当前位置（单次定位）
 */
export async function getCurrentLocation(): Promise<Coordinates | ReGeocode> {
  return ExpoGaodeMapModule.getCurrentLocation?.();
}

/**
 * 添加定位监听器
 */
export function addLocationListener(listener: LocationListener): EventSubscription {
  return ExpoGaodeMapModule.addListener?.('onLocationUpdate', listener) || {
    remove: () => {},
  } as EventSubscription;
}

/**
 * 坐标转换
 */
export async function coordinateConvert(
  coordinate: LatLng,
  type: CoordinateType
): Promise<LatLng> {
  return ExpoGaodeMapModule.coordinateConvert?.(coordinate, type) || Promise.resolve(coordinate);
}

/**
 * 开始获取设备朝向
 * @platform ios
 */
export function startUpdatingHeading(): void {
  ExpoGaodeMapModule.startUpdatingHeading?.();
}

/**
 * 停止获取设备朝向
 * @platform ios
 */
export function stopUpdatingHeading(): void {
  ExpoGaodeMapModule.stopUpdatingHeading?.();
}

/**
 * 设置 API Key
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
