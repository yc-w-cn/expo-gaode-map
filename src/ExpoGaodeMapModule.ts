/*
 * @Author       : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @Date         : 2025-11-13 14:03:56
 * @LastEditors  : 尚博信_王强 wangqiang03@sunboxsoft.com
 * @LastEditTime : 2025-11-13 14:58:00
 * @FilePath     : /expo-gaode-map/src/ExpoGaodeMapModule.ts
 * @Description  : 
 * 
 * Copyright (c) 2025 by 尚博信_王强, All Rights Reserved. 
 */
import { NativeModule, requireNativeModule } from 'expo';
import type { ExpoGaodeMapModuleEvents } from './ExpoGaodeMap.types';


declare class ExpoGaodeMapModule extends NativeModule<ExpoGaodeMapModuleEvents> {
  // 地图控制方法已移至 MapView 的 ref 调用
  // 使用方式: mapRef.current.moveCamera() 等
}

// This call loads the native module object from the JSI.
export default requireNativeModule<ExpoGaodeMapModule>('ExpoGaodeMap');
