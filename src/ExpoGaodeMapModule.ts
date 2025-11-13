import { NativeModule, requireNativeModule } from 'expo';

import { ExpoGaodeMapModuleEvents } from './ExpoGaodeMap.types';

declare class ExpoGaodeMapModule extends NativeModule<ExpoGaodeMapModuleEvents> {
  PI: number;
  hello(): string;
  setValueAsync(value: string): Promise<void>;
}

// This call loads the native module object from the JSI.
export default requireNativeModule<ExpoGaodeMapModule>('ExpoGaodeMap');
