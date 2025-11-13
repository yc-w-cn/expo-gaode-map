/*
 * @Author       : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @Date         : 2025-11-13 15:02:35
 * @LastEditors  : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @LastEditTime : 2025-11-13 18:19:09
 * @FilePath     : /expo-gaode-map/src/components/overlays/MultiPoint.tsx
 * @Description  : 地图海量点组件
 * 
 * Copyright (c) 2025 by 尚博信_王强, All Rights Reserved. 
 */

import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';
import type { MultiPointProps } from '../../types';

const NativeMultiPoint = requireNativeViewManager('ExpoGaodeMap_MultiPointView');

/**
 * 地图海量点组件
 * 用于展示大量标记点，性能优于普通 Marker
 * 
 * @example
 * ```tsx
 * <MapView>
 *   <MultiPoint
 *     points={[
 *       { latitude: 39.9, longitude: 116.4, id: '1' },
 *       { latitude: 39.91, longitude: 116.41, id: '2' },
 *     ]}
 *     icon={require('./marker.png')}
 *   />
 * </MapView>
 * ```
 */
export default function MultiPoint(props: MultiPointProps) {
  return <NativeMultiPoint {...props} />;
}
