/*
 * @Author       : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @Date         : 2025-11-13 15:02:00
 * @LastEditors  : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @LastEditTime : 2025-11-13 18:43:00
 * @FilePath     : /expo-gaode-map/src/components/overlays/Circle.tsx
 * @Description  : 地图圆形组件 - 使用命令式 API
 * 
 * Copyright (c) 2025 by 尚博信_王强, All Rights Reserved. 
 */

import * as React from 'react';
import type { CircleProps } from '../../types';
import { MapContext } from '../../ExpoGaodeMapView';

/**
 * 地图圆形组件
 * 
 * @example
 * ```tsx
 * <MapView>
 *   <Circle
 *     center={{ latitude: 39.9, longitude: 116.4 }}
 *     radius={1000}
 *     fillColor={0x440000FF}
 *     strokeColor={0xFFFF0000}
 *   />
 * </MapView>
 * ```
 */
export default function Circle(props: CircleProps) {
  const mapRef = React.useContext(MapContext);
  const circleIdRef = React.useRef<string | null>(null);
  
  console.log('Circle 组件渲染，props:', JSON.stringify(props));
  
  React.useEffect(() => {
    console.log('Circle useEffect - 添加圆形到地图');
    
    if (!mapRef?.current) {
      console.warn('MapRef 不可用');
      return;
    }
    
    // 添加圆形
    const circleId = `circle_${Date.now()}_${Math.random()}`;
    circleIdRef.current = circleId;
    
    mapRef.current.addCircle(circleId, props);
    console.log('✅ 圆形已添加:', circleId);
    
    // 清理函数 - 移除圆形
    return () => {
      console.log('Circle useEffect cleanup - 移除圆形');
      if (circleIdRef.current && mapRef?.current) {
        mapRef.current.removeCircle(circleIdRef.current);
        console.log('✅ 圆形已移除:', circleIdRef.current);
      }
    };
  }, []);
  
  // 当 props 变化时更新圆形
  React.useEffect(() => {
    console.log('Circle props 变化，更新圆形');
    if (circleIdRef.current && mapRef?.current) {
      mapRef.current.updateCircle(circleIdRef.current, props);
      console.log('✅ 圆形已更新:', circleIdRef.current);
    }
  }, [props.center, props.radius, props.fillColor, props.strokeColor, props.strokeWidth]);
  
  // 不渲染任何 UI
  return null;
}
