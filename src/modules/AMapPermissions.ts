/*
 * @Author       : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @Date         : 2025-11-15 02:20:56
 * @LastEditors  : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @LastEditTime : 2025-11-15 02:20:58
 * @FilePath     : /expo-gaode-map/src/modules/AMapPermissions.ts
 * @Description  : 
 * 
 * Copyright (c) 2025 by 尚博信_王强, All Rights Reserved. 
 */
/*
 * 高德地图权限管理模块
 */

import ExpoGaodeMapModule from '../ExpoGaodeMapModule';

/**
 * 权限状态
 */
export interface PermissionStatus {
  /** 是否已授权 */
  granted: boolean;
  /** iOS 权限状态字符串 */
  status?: 'notDetermined' | 'restricted' | 'denied' | 'authorizedAlways' | 'authorizedWhenInUse' | 'unknown';
  /** Android 精确位置权限 */
  fineLocation?: boolean;
  /** Android 粗略位置权限 */
  coarseLocation?: boolean;
}

/**
 * 检查位置权限状态
 */
export async function checkLocationPermission(): Promise<PermissionStatus> {
  return await ExpoGaodeMapModule.checkLocationPermission();
}

/**
 * 请求位置权限
 */
export async function requestLocationPermission(): Promise<PermissionStatus> {
  return await ExpoGaodeMapModule.requestLocationPermission();
}

export default {
  checkLocationPermission,
  requestLocationPermission,
};