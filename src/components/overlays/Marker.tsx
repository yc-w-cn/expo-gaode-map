import * as React from 'react';
import { Image } from 'react-native';
import { MapContext, MarkerEventContext } from '../../ExpoGaodeMapView';
import type { MarkerProps } from '../../types';

export default function Marker(props: MarkerProps) {
  return <MarkerImperative {...props} />;
}

function MarkerImperative(props: MarkerProps) {
  const mapRef = React.useContext(MapContext);
  const eventManager = React.useContext(MarkerEventContext);
  const markerIdRef = React.useRef<string | null>(null);
  const propsRef = React.useRef(props);
  
  React.useEffect(() => {
    propsRef.current = props;
  }, [props]);
  
  React.useEffect(() => {
    const checkAndAdd = () => {
      if (!mapRef?.current) {
        setTimeout(checkAndAdd, 50);
        return;
      }
      
      const markerId = `marker_${Date.now()}_${Math.random()}`;
      markerIdRef.current = markerId;
      
      if (eventManager) {
        eventManager.register(markerId, {
          onPress: props.onPress,
          onDragStart: props.onDragStart,
          onDrag: props.onDrag,
          onDragEnd: props.onDragEnd,
        });
      }
      
      const processedProps = { ...propsRef.current };
      if (processedProps.icon && typeof processedProps.icon === 'number') {
        const resolved = Image.resolveAssetSource(processedProps.icon);
        processedProps.icon = resolved;
      }
      
      mapRef.current.addMarker(markerId, processedProps);
    };
    
    checkAndAdd();
    
    return () => {
      if (markerIdRef.current) {
        if (eventManager) {
          eventManager.unregister(markerIdRef.current);
        }
        if (mapRef?.current) {
          mapRef.current.removeMarker(markerIdRef.current);
        }
      }
    };
  }, []);

  React.useEffect(() => {
    if (markerIdRef.current && eventManager) {
      eventManager.register(markerIdRef.current, {
        onPress: props.onPress,
        onDragStart: props.onDragStart,
        onDrag: props.onDrag,
        onDragEnd: props.onDragEnd,
      });
    }
  }, [props.onPress, props.onDragStart, props.onDrag, props.onDragEnd]);

  React.useEffect(() => {
    if (markerIdRef.current && mapRef?.current) {
      const processedProps = { ...props };
      if (processedProps.icon && typeof processedProps.icon === 'number') {
        const resolved = Image.resolveAssetSource(processedProps.icon);
        processedProps.icon = resolved;
      }
      mapRef.current.updateMarker(markerIdRef.current, processedProps);
    }
  }, [
    props.position?.latitude,
    props.position?.longitude,
    props.title,
    props.draggable,
    props.icon,
    props.iconWidth,
    props.iconHeight,
    props.pinColor
  ]);
  
  return null;
}
