// Reexport the native module. On web, it will be resolved to ExpoGaodeMapModule.web.ts
// and on native platforms to ExpoGaodeMapModule.ts
export { default } from './ExpoGaodeMapModule';
export { default as ExpoGaodeMapView } from './ExpoGaodeMapView';
export * from  './ExpoGaodeMap.types';
