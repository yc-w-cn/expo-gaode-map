/*
 * @Author       : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @Date         : 2025-11-13 15:01:45
 * @LastEditors  : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @LastEditTime : 2025-11-13 19:24:22
 * @FilePath     : /expo-gaode-map/src/components/overlays/Polygon.tsx
 * @Description  : 地图多边形组件 - 命令式 API
 * 
 * Copyright (c) 2025 by 尚博信_王强, All Rights Reserved. 
 */


import { useContext, useEffect, useRef } from 'react';
import type { PolygonProps } from '../../types';
import { MapContext } from '../../ExpoGaodeMapView';

/**
 * 地图多边形组件 - 命令式 API
 * 
 * @example
 * ```tsx
 * <MapView>
 *   <Polygon
 *     points={[
 *       { latitude: 39.9, longitude: 116.4 },
 *       { latitude: 39.91, longitude: 116.41 },
 *       { latitude: 39.92, longitude: 116.40 },
 *     ]}
 *     fillColor={0x44FF0000}
 *     strokeColor={-65536}
 *     strokeWidth={5}
 *   />
 * </MapView>
 * ```
 */
export default function Polygon(props: PolygonProps) {
  const { points, fillColor, strokeColor, strokeWidth, zIndex } = props;
  const nativeRef = useContext(MapContext);
  const polygonIdRef = useRef<string>(`polygon_${Date.now()}_${Math.random()}`);

  useEffect(() => {
    const polygonId = polygonIdRef.current;

    // 添加多边形
    if (nativeRef?.current && points && points.length >= 3) {
      try {
        console.log('🟦 Polygon 组件调用 addPolygon:', polygonId, {
          points,
          fillColor: fillColor ?? 0x440000FF,
          strokeColor: strokeColor ?? -16776961,
          strokeWidth: strokeWidth ?? 10,
          zIndex: zIndex ?? 0,
        });
        
        nativeRef.current.addPolygon(polygonId, {
          points,
          fillColor: fillColor ?? 0x440000FF,
          strokeColor: strokeColor ?? -16776961,
          strokeWidth: strokeWidth ?? 10,
          zIndex: zIndex ?? 0,
        });
        
        console.log('✅ Polygon addPolygon 调用完成');
      } catch (error) {
        console.error('❌ 添加多边形失败:', error);
      }
    } else {
      console.warn('⚠️ Polygon 组件条件不满足:', {
        hasNativeRef: !!nativeRef?.current,
        hasPoints: !!points,
        pointsLength: points?.length,
      });
    }

    // 清理函数
    return () => {
      if (nativeRef?.current) {
        try {
          nativeRef.current.removePolygon(polygonId);
        } catch (error) {
          console.error('移除多边形失败:', error);
        }
      }
    };
  }, []);

  // 更新多边形属性
  useEffect(() => {
    const polygonId = polygonIdRef.current;

    if (nativeRef?.current) {
      try {
        nativeRef.current.updatePolygon(polygonId, {
          points,
          fillColor,
          strokeColor,
          strokeWidth,
          zIndex,
        });
      } catch (error) {
        console.error('更新多边形失败:', error);
      }
    }
  }, [points, fillColor, strokeColor, strokeWidth, zIndex]);

  return null;
}
