/*
 * @Author       : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @Date         : 2025-11-13 14:03:56
 * @LastEditors  : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @LastEditTime : 2025-11-13 19:35:20
 * @FilePath     : /expo-gaode-map/src/ExpoGaodeMapView.tsx
 * @Description  : 高德地图视图组件
 * 
 * Copyright (c) 2025 by 尚博信_王强, All Rights Reserved. 
 */

import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';

import type { 
  MapViewProps, 
  MapViewRef,
  NativeMapViewRef,
  CameraPosition, 
  LatLng, 
  Point, 
  CircleProps,
  MarkerProps,
  PolylineProps,
  PolygonProps,
} from './types';

// 重新导出 MapViewRef 供外部使用
export type { MapViewRef } from './types';

const NativeView: React.ComponentType<MapViewProps & { ref?: React.Ref<NativeMapViewRef> }> = requireNativeViewManager('ExpoGaodeMap');

// 创建 Context 用于子组件访问 MapRef
export const MapContext = React.createContext<React.RefObject<MapViewRef | null> | null>(null);

/**
 * 高德地图视图组件
 * 
 * @example
 * ```tsx
 * import { MapView } from 'expo-gaode-map';
 * 
 * function MyMap() {
 *   const mapRef = React.useRef(null);
 *   
 *   return (
 *     <MapView
 *       ref={mapRef}
 *       style={{ flex: 1 }}
 *       initialCameraPosition={{
 *         target: { latitude: 39.9, longitude: 116.4 },
 *         zoom: 10,
 *       }}
 *       onLoad={() => console.log('地图加载完成')}
 *     />
 *   );
 * }
 * ```
 */
const ExpoGaodeMapView = React.forwardRef<MapViewRef, MapViewProps>((props, ref) => {
  const nativeRef = React.useRef<NativeMapViewRef>(null);
  const internalRef = React.useRef<MapViewRef | null>(null);

  const apiRef: MapViewRef = React.useMemo(() => ({
    moveCamera: async (position: CameraPosition, duration: number = 0) => {
      if (!nativeRef.current) throw new Error('MapView not initialized');
      return nativeRef.current.moveCamera(position, duration);
    },
    getLatLng: async (point: Point) => {
      if (!nativeRef.current) throw new Error('MapView not initialized');
      return nativeRef.current.getLatLng(point);
    },
    setCenter: async (center: LatLng, animated: boolean = false) => {
      if (!nativeRef.current) throw new Error('MapView not initialized');
      return nativeRef.current.setCenter(center, animated);
    },
    setZoom: async (zoom: number, animated: boolean = false) => {
      if (!nativeRef.current) throw new Error('MapView not initialized');
      return nativeRef.current.setZoom(zoom, animated);
    },
    getCameraPosition: async () => {
      if (!nativeRef.current) throw new Error('MapView not initialized');
      return nativeRef.current.getCameraPosition();
    },
    addCircle: async (id: string, props: CircleProps) => {
      if (!nativeRef.current) throw new Error('MapView not initialized');
      return nativeRef.current.addCircle(id, props);
    },
    removeCircle: async (id: string) => {
      if (!nativeRef.current) throw new Error('MapView not initialized');
      return nativeRef.current.removeCircle(id);
    },
    updateCircle: async (id: string, props: Partial<CircleProps>) => {
      if (!nativeRef.current) throw new Error('MapView not initialized');
      return nativeRef.current.updateCircle(id, props);
    },
    addMarker: async (id: string, props: MarkerProps) => {
      if (!nativeRef.current) throw new Error('MapView not initialized');
      return nativeRef.current.addMarker(id, props);
    },
    removeMarker: async (id: string) => {
      if (!nativeRef.current) throw new Error('MapView not initialized');
      return nativeRef.current.removeMarker(id);
    },
    updateMarker: async (id: string, props: Partial<MarkerProps>) => {
      if (!nativeRef.current) throw new Error('MapView not initialized');
      return nativeRef.current.updateMarker(id, props);
    },
    addPolyline: async (id: string, props: PolylineProps) => {
      if (!nativeRef.current) throw new Error('MapView not initialized');
      return nativeRef.current.addPolyline(id, props);
    },
    removePolyline: async (id: string) => {
      if (!nativeRef.current) throw new Error('MapView not initialized');
      return nativeRef.current.removePolyline(id);
    },
    updatePolyline: async (id: string, props: Partial<PolylineProps>) => {
      if (!nativeRef.current) throw new Error('MapView not initialized');
      return nativeRef.current.updatePolyline(id, props);
    },
    addPolygon: async (id: string, props: PolygonProps) => {
      if (!nativeRef.current) throw new Error('MapView not initialized');
      return nativeRef.current.addPolygon(id, props);
    },
    removePolygon: async (id: string) => {
      if (!nativeRef.current) throw new Error('MapView not initialized');
      return nativeRef.current.removePolygon(id);
    },
    updatePolygon: async (id: string, props: Partial<PolygonProps>) => {
      if (!nativeRef.current) throw new Error('MapView not initialized');
      return nativeRef.current.updatePolygon(id, props);
    },
  }), []);

  // 设置 internalRef 和外部 ref
  React.useEffect(() => {
    internalRef.current = apiRef;
  }, [apiRef]);

  React.useImperativeHandle(ref, () => apiRef, [apiRef]);

  return (
    <MapContext.Provider value={internalRef}>
      <NativeView ref={nativeRef} {...props} />
    </MapContext.Provider>
  );
});

ExpoGaodeMapView.displayName = 'ExpoGaodeMapView';

export default ExpoGaodeMapView;
