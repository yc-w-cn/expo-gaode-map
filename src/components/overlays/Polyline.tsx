/*
 * @Author       : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @Date         : 2025-11-13 15:01:30
 * @LastEditors  : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @LastEditTime : 2025-11-13 19:06:00
 * @FilePath     : /expo-gaode-map/src/components/overlays/Polyline.tsx
 * @Description  : 地图折线组件 - 使用命令式 API
 * 
 * Copyright (c) 2025 by 尚博信_王强, All Rights Reserved. 
 */

import * as React from 'react';
import { MapContext } from '../../ExpoGaodeMapView';
import type { PolylineProps } from '../../types';

/**
 * 地图折线组件
 * 
 * @example
 * ```tsx
 * <MapView>
 *   <Polyline
 *     points={[
 *       { latitude: 39.9, longitude: 116.4 },
 *       { latitude: 39.91, longitude: 116.41 },
 *     ]}
 *     color="#FF0000"
 *     width={5}
 *   />
 * </MapView>
 * ```
 */
export default function Polyline(props: PolylineProps) {
  const mapRef = React.useContext(MapContext);
  const polylineIdRef = React.useRef<string>(`polyline_${Date.now()}_${Math.random()}`);

  console.log('Polyline 组件渲染，props:', props);

  // 添加折线
  React.useEffect(() => {
    const polylineId = polylineIdRef.current;
    
    console.log('Polyline useEffect - 添加折线到地图');
    mapRef?.current?.addPolyline?.(polylineId, props).then(() => {
      console.log('✅ 折线已添加:', polylineId);
    }).catch((error: any) => {
      console.error('❌ 添加折线失败:', error);
    });

    return () => {
      console.log('Polyline useEffect cleanup - 移除折线');
      mapRef?.current?.removePolyline?.(polylineId).catch((error: any) => {
        console.error('❌ 移除折线失败:', error);
      });
    };
  }, []);

  // 监听 Props 变化，更新折线
  React.useEffect(() => {
    const polylineId = polylineIdRef.current;
    
    console.log('Polyline props 变化，更新折线:', props);
    mapRef?.current?.updatePolyline?.(polylineId, props).catch((error: any) => {
      console.error('❌ 更新折线失败:', error);
    });
  }, [props.points, props.width, props.color]);

  return null;
}
