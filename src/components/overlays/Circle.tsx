import * as React from 'react';
import type { CircleProps } from '../../types';
import { MapContext, CircleEventContext } from '../../ExpoGaodeMapView';

export default function Circle(props: CircleProps) {
  const mapRef = React.useContext(MapContext);
  const eventManager = React.useContext(CircleEventContext);
  const circleIdRef = React.useRef<string | null>(null);
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
      
      const circleId = `circle_${Date.now()}_${Math.random()}`;
      circleIdRef.current = circleId;
      
      if (eventManager && props.onPress) {
        eventManager.register(circleId, {
          onPress: props.onPress,
        });
      }
      
      mapRef.current.addCircle(circleId, propsRef.current);
    };
    
    checkAndAdd();
    
    return () => {
      if (circleIdRef.current) {
        if (eventManager) {
          eventManager.unregister(circleIdRef.current);
        }
        if (mapRef?.current) {
          mapRef.current.removeCircle(circleIdRef.current);
        }
      }
    };
  }, []);

  React.useEffect(() => {
    if (circleIdRef.current && mapRef?.current) {
      mapRef.current.updateCircle(circleIdRef.current, props);
    }
  }, [props.center, props.radius, props.fillColor, props.strokeColor, props.strokeWidth]);
  
  return null;
}
