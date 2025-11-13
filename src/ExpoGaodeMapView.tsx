import { requireNativeView } from 'expo';
import * as React from 'react';

import { ExpoGaodeMapViewProps } from './ExpoGaodeMap.types';

const NativeView: React.ComponentType<ExpoGaodeMapViewProps> =
  requireNativeView('ExpoGaodeMap');

export default function ExpoGaodeMapView(props: ExpoGaodeMapViewProps) {
  return <NativeView {...props} />;
}
