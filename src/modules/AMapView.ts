/*
 * @Author       : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @Date         : 2025-11-13 14:57:30
 * @LastEditors  : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @LastEditTime : 2025-11-13 14:57:35
 * @FilePath     : /expo-gaode-map/src/modules/AMapView.ts
 * @Description  : 高德地图视图控制模块
 * 
 * Copyright (c) 2025 by 尚博信_王强, All Rights Reserved. 
 */

import ExpoGaodeMapModule from '../ExpoGaodeMapModule';
import type { CameraPosition, Point, LatLng } from '../types';

/**
 * 移动地图相机到指定位置
 * @param cameraPosition 相机位置参数
 * @param duration 动画时长（毫秒），默认为0（无动画）
 */
export function moveCamera(cameraPosition: CameraPosition, duration = 0): void {
  ExpoGaodeMapModule.moveCamera?.(cameraPosition, duration);
}

/**
 * 将屏幕坐标转换为地理坐标
 * @param point 屏幕坐标点
 * @returns 地理坐标
 */
export async function getLatLng(point: Point): Promise<LatLng> {
  return ExpoGaodeMapModule.getLatLng?.(point) || Promise.resolve({ latitude: 0, longitude: 0 });
}

/**
 * 设置地图中心点
 * @param center 中心点坐标
 * @param animated 是否使用动画
 */
export function setCenter(center: LatLng, animated = true): void {
  ExpoGaodeMapModule.setCenter?.(center, animated);
}

/**
 * 设置地图缩放级别
 * @param zoom 缩放级别（3-20）
 * @param animated 是否使用动画
 */
export function setZoom(zoom: number, animated = true): void {
  ExpoGaodeMapModule.setZoom?.(zoom, animated);
}

/**
 * 获取当前地图状态
 * @returns 当前相机位置
 */
export async function getCameraPosition(): Promise<CameraPosition> {
  return ExpoGaodeMapModule.getCameraPosition?.() || Promise.resolve({
    target: { latitude: 0, longitude: 0 },
    zoom: 10,
  });
}

export default {
  moveCamera,
  getLatLng,
  setCenter,
  setZoom,
  getCameraPosition,
};
