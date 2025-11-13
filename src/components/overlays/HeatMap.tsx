/*
 * @Author       : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @Date         : 2025-11-13 15:02:15
 * @LastEditors  : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @LastEditTime : 2025-11-13 18:12:07
 * @FilePath     : /expo-gaode-map/src/components/overlays/HeatMap.tsx
 * @Description  : 地图热力图组件
 * 
 * Copyright (c) 2025 by 尚博信_王强, All Rights Reserved. 
 */

import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';
import type { HeatMapProps } from '../../types';

const NativeHeatMap = requireNativeViewManager('ExpoGaodeMap_HeatMapView');

/**
 * 地图热力图组件
 * 
 * @example
 * ```tsx
 * <MapView>
 *   <HeatMap
 *     data={[
 *       { latitude: 39.9, longitude: 116.4, intensity: 100 },
 *       { latitude: 39.91, longitude: 116.41, intensity: 80 },
 *     ]}
 *     radius={50}
 *     opacity={0.6}
 *   />
 * </MapView>
 * ```
 */
export default function HeatMap(props: HeatMapProps) {
  return <NativeHeatMap {...props} />;
}
