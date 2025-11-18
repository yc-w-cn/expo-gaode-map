import { NativeModule, requireNativeModule } from 'expo';
import type { ExpoGaodeMapModuleEvents } from './ExpoGaodeMap.types';
import type { LatLng, CoordinateType } from './types';

declare class ExpoGaodeMapModule extends NativeModule<ExpoGaodeMapModuleEvents> {
  // SDK 初始化
  initSDK(config: { androidKey?: string; iosKey?: string }): void;
  getVersion(): string;
  
  // 定位控制
  start(): void;
  stop(): void;
  isStarted(): Promise<boolean>;
  getCurrentLocation(): Promise<any>;
  coordinateConvert(coordinate: LatLng, type: CoordinateType): Promise<LatLng>;
  
  // 定位配置
  setLocatingWithReGeocode(isReGeocode: boolean): void;
  setLocationMode(mode: number): void;
  setInterval(interval: number): void;
  setOnceLocation(isOnceLocation: boolean): void;
  setSensorEnable(sensorEnable: boolean): void;
  setWifiScan(wifiScan: boolean): void;
  setGpsFirst(gpsFirst: boolean): void;
  setOnceLocationLatest(onceLocationLatest: boolean): void;
  setGeoLanguage(language: string): void;
  setLocationCacheEnable(locationCacheEnable: boolean): void;
  setHttpTimeOut(httpTimeOut: number): void;
  setDesiredAccuracy(accuracy: number): void;
  setLocationTimeout(timeout: number): void;
  setReGeocodeTimeout(timeout: number): void;
  setDistanceFilter(distance: number): void;
  setPausesLocationUpdatesAutomatically(pauses: boolean): void;
  setAllowsBackgroundLocationUpdates(allows: boolean): void;
  setLocationProtocol(protocol: string): void;
  
  // 方向更新 (iOS)
  startUpdatingHeading(): void;
  stopUpdatingHeading(): void;
  
  // 权限
  checkLocationPermission(): Promise<any>;
  requestLocationPermission(): Promise<any>;
}

export default requireNativeModule<ExpoGaodeMapModule>('ExpoGaodeMap');
