/*
 * @Author       : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @Date         : 2025-11-13 15:01:10
 * @LastEditors  : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @LastEditTime : 2025-11-13 18:55:00
 * @FilePath     : /expo-gaode-map/src/components/overlays/Marker.tsx
 * @Description  : 地图标记组件 - 使用命令式 API
 * 
 * Copyright (c) 2025 by 尚博信_王强, All Rights Reserved. 
 */

import * as React from 'react';
import { MapContext } from '../../ExpoGaodeMapView';
import type { MarkerProps } from '../../types';

/**
 * 地图标记组件
 * 
 * @example
 * ```tsx
 * <MapView>
 *   <Marker
 *     position={{ latitude: 39.9, longitude: 116.4 }}
 *     title="标记点"
 *     onPress={() => console.log('Marker pressed')}
 *   />
 * </MapView>
 * ```
 */
export default function Marker(props: MarkerProps) {
  const mapRef = React.useContext(MapContext);
  const markerIdRef = React.useRef<string>(`marker_${Date.now()}_${Math.random()}`);

  console.log('Marker 组件渲染，props:', props);

  // 添加标记
  React.useEffect(() => {
    const markerId = markerIdRef.current;
    
    console.log('Marker useEffect - 添加标记到地图');
    mapRef?.current?.addMarker?.(markerId, props).then(() => {
      console.log('✅ 标记已添加:', markerId);
    }).catch((error: any) => {
      console.error('❌ 添加标记失败:', error);
    });

    return () => {
      console.log('Marker useEffect cleanup - 移除标记');
      mapRef?.current?.removeMarker?.(markerId).catch((error: any) => {
        console.error('❌ 移除标记失败:', error);
      });
    };
  }, []);

  // 监听 Props 变化，更新标记
  React.useEffect(() => {
    const markerId = markerIdRef.current;
    
    console.log('Marker props 变化，更新标记:', props);
    mapRef?.current?.updateMarker?.(markerId, props).catch((error: any) => {
      console.error('❌ 更新标记失败:', error);
    });
  }, [props.position, props.title, props.draggable]);

  return null;
}
