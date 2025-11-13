import * as React from 'react';

import { ExpoGaodeMapViewProps } from './ExpoGaodeMap.types';

export default function ExpoGaodeMapView(props: ExpoGaodeMapViewProps) {
  return (
    <div>
      <iframe
        style={{ flex: 1 }}
        src={props.url}
        onLoad={() => props.onLoad({ nativeEvent: { url: props.url } })}
      />
    </div>
  );
}
