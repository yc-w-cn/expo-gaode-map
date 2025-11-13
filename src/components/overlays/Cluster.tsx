/*
 * @Author       : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @Date         : 2025-11-13 15:02:50
 * @LastEditors  : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @LastEditTime : 2025-11-13 18:19:20
 * @FilePath     : /expo-gaode-map/src/components/overlays/Cluster.tsx
 * @Description  : 地图点聚合组件
 * 
 * Copyright (c) 2025 by 尚博信_王强, All Rights Reserved. 
 */

import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';
import type { ClusterProps } from '../../types';

const NativeCluster = requireNativeViewManager('ExpoGaodeMap_ClusterView');

/**
 * 地图点聚合组件
 * 将相近的标记点聚合显示，提高大量标记的展示性能
 * 
 * @example
 * ```tsx
 * <MapView>
 *   <Cluster
 *     points={[
 *       { latitude: 39.9, longitude: 116.4, id: '1' },
 *       { latitude: 39.91, longitude: 116.41, id: '2' },
 *     ]}
 *     radius={60}
 *     minClusterSize={2}
 *   />
 * </MapView>
 * ```
 */
export default function Cluster(props: ClusterProps) {
  return <NativeCluster {...props} />;
}
