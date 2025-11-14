package expo.modules.gaodemap.managers

import android.util.Log
import android.graphics.BitmapFactory
import com.amap.api.maps.AMap
import com.amap.api.maps.model.LatLng
import com.amap.api.maps.model.BitmapDescriptorFactory
import expo.modules.gaodemap.utils.ColorParser
import java.net.URL

/**
 * 覆盖物管理器
 * 负责地图上所有覆盖物的添加、删除、更新
 */
class OverlayManager(private val aMap: AMap) {
  
  companion object {
    private const val TAG = "OverlayManager"
  }
  
  // 覆盖物存储
  private val circles = mutableMapOf<String, com.amap.api.maps.model.Circle>()
  private val markers = mutableMapOf<String, com.amap.api.maps.model.Marker>()
  private val polylines = mutableMapOf<String, com.amap.api.maps.model.Polyline>()
  private val polygons = mutableMapOf<String, com.amap.api.maps.model.Polygon>()
  
  // ==================== 圆形覆盖物 ====================
  
  fun addCircle(id: String, props: Map<String, Any>) {
    
    @Suppress("UNCHECKED_CAST")
    val center = props["center"] as? Map<String, Double>
    val radius = (props["radius"] as? Number)?.toDouble() ?: 1000.0
    val fillColor = ColorParser.parseColor(props["fillColor"])
    val strokeColor = ColorParser.parseColor(props["strokeColor"])
    val strokeWidth = (props["strokeWidth"] as? Number)?.toFloat() ?: 10f
    
    if (center != null) {
      val lat = center["latitude"] ?: 0.0
      val lng = center["longitude"] ?: 0.0
      val latLng = LatLng(lat, lng)
      
      val options = com.amap.api.maps.model.CircleOptions()
        .center(latLng)
        .radius(radius)
        .fillColor(fillColor)
        .strokeColor(strokeColor)
        .strokeWidth(strokeWidth)
      
      val circle = aMap.addCircle(options)
      circles[id] = circle
    }
  }
  
  fun removeCircle(id: String) {
    circles[id]?.let { circle ->
      circle.remove()
      circles.remove(id)
    }
  }
  
  fun updateCircle(id: String, props: Map<String, Any>) {
    circles[id]?.let { circle ->
      @Suppress("UNCHECKED_CAST")
      val center = props["center"] as? Map<String, Double>
      val radius = (props["radius"] as? Number)?.toDouble()
      val fillColor = props["fillColor"]?.let { ColorParser.parseColor(it) }
      val strokeColor = props["strokeColor"]?.let { ColorParser.parseColor(it) }
      val strokeWidth = (props["strokeWidth"] as? Number)?.toFloat()
      
      center?.let {
        val lat = it["latitude"] ?: 0.0
        val lng = it["longitude"] ?: 0.0
        circle.center = LatLng(lat, lng)
      }
      
      radius?.let { circle.radius = it }
      fillColor?.let { circle.fillColor = it }
      strokeColor?.let { circle.strokeColor = it }
      strokeWidth?.let { circle.strokeWidth = it }
    }
  }
  
  // ==================== 标记点 ====================
  
  fun addMarker(id: String, props: Map<String, Any>) {
    
    @Suppress("UNCHECKED_CAST")
    val position = props["position"] as? Map<String, Double>
    val title = props["title"] as? String
    val draggable = props["draggable"] as? Boolean ?: false
    
    if (position != null) {
      val lat = position["latitude"] ?: 0.0
      val lng = position["longitude"] ?: 0.0
      val latLng = LatLng(lat, lng)
      
      val options = com.amap.api.maps.model.MarkerOptions()
        .position(latLng)
        .draggable(draggable)
      
      title?.let { options.title(it) }
      
      val marker = aMap.addMarker(options)
      
      if (!title.isNullOrEmpty()) {
        marker?.showInfoWindow()
      }
      
      markers[id] = marker
    }
  }
  
  fun removeMarker(id: String) {
    markers[id]?.let { marker ->
      marker.remove()
      markers.remove(id)
    }
  }
  
  fun updateMarker(id: String, props: Map<String, Any>) {
    markers[id]?.let { marker ->
      @Suppress("UNCHECKED_CAST")
      val position = props["position"] as? Map<String, Double>
      val title = props["title"] as? String
      val draggable = props["draggable"] as? Boolean
      
      position?.let {
        val lat = it["latitude"] ?: 0.0
        val lng = it["longitude"] ?: 0.0
        marker.position = LatLng(lat, lng)
      }
      
      title?.let { marker.title = it }
      draggable?.let { marker.isDraggable = it }
    }
  }
  
  // ==================== 折线 ====================
  
  fun addPolyline(id: String, props: Map<String, Any>) {
    
    @Suppress("UNCHECKED_CAST")
    val points = props["points"] as? List<Map<String, Double>>
    val width = (props["strokeWidth"] as? Number)?.toFloat() ?: 10f
    val texture = props["texture"] as? String
    val color = if (!texture.isNullOrEmpty()) {
      android.graphics.Color.TRANSPARENT
    } else {
      ColorParser.parseColor(props["strokeColor"])
    }
    
    if (points != null && points.size >= 2) {
      val latLngs = points.map { point ->
        val lat = point["latitude"] ?: 0.0
        val lng = point["longitude"] ?: 0.0
        LatLng(lat, lng)
      }
      
      val options = com.amap.api.maps.model.PolylineOptions()
        .addAll(latLngs)
        .width(width)
        .color(color)
      
      val polyline = aMap.addPolyline(options)
      
      // 处理纹理
      if (!texture.isNullOrEmpty()) {
        Thread {
          try {
            val bitmap = if (texture.startsWith("http://") || texture.startsWith("https://")) {
              BitmapFactory.decodeStream(URL(texture).openStream())
            } else if (texture.startsWith("file://")) {
              BitmapFactory.decodeFile(texture.substring(7))
            } else {
              null
            }
            
            bitmap?.let {
              val descriptor = BitmapDescriptorFactory.fromBitmap(it)
              polyline.setCustomTexture(descriptor)
              Log.d(TAG, "✅ 纹理设置成功")
            }
          } catch (e: Exception) {
            Log.e(TAG, "纹理加载失败: ${e.message}")
          }
        }.start()
      }
      
      polylines[id] = polyline
    }
  }
  
  fun removePolyline(id: String) {
    polylines[id]?.let { polyline ->
      polyline.remove()
      polylines.remove(id)
    }
  }
  
  fun updatePolyline(id: String, props: Map<String, Any>) {
    polylines[id]?.let { polyline ->
      @Suppress("UNCHECKED_CAST")
      val points = props["points"] as? List<Map<String, Double>>
      val width = (props["strokeWidth"] as? Number)?.toFloat()
      val color = props["strokeColor"]?.let { ColorParser.parseColor(it) }
      
      points?.let {
        val latLngs = it.map { point ->
          val lat = point["latitude"] ?: 0.0
          val lng = point["longitude"] ?: 0.0
          LatLng(lat, lng)
        }
        polyline.points = latLngs
      }
      
      width?.let { polyline.width = it }
      color?.let { polyline.color = it }
    }
  }
  
  // ==================== 多边形 ====================
  
  fun addPolygon(id: String, props: Map<String, Any>) {
    
    @Suppress("UNCHECKED_CAST")
    val points = props["points"] as? List<Map<String, Double>>
    val fillColor = ColorParser.parseColor(props["fillColor"])
    val strokeColor = ColorParser.parseColor(props["strokeColor"])
    
    val strokeWidth = (props["strokeWidth"] as? Number)?.toFloat() ?: 10f
    val zIndex = (props["zIndex"] as? Number)?.toFloat() ?: 0f
    
    if (points != null && points.size >= 3) {
      val latLngs = points.map { point ->
        val lat = point["latitude"] ?: 0.0
        val lng = point["longitude"] ?: 0.0
        LatLng(lat, lng)
      }
      
      val options = com.amap.api.maps.model.PolygonOptions()
        .addAll(latLngs)
        .fillColor(fillColor)
        .strokeColor(strokeColor)
        .strokeWidth(strokeWidth)
        .zIndex(zIndex)
      
      val polygon = aMap.addPolygon(options)
      polygons[id] = polygon
      Log.d(TAG, "✅ 多边形创建成功")
    }
  }
  
  fun removePolygon(id: String) {
    polygons[id]?.let { polygon ->
      polygon.remove()
      polygons.remove(id)
    }
  }
  
  fun updatePolygon(id: String, props: Map<String, Any>) {
    polygons[id]?.let { polygon ->
      @Suppress("UNCHECKED_CAST")
      val points = props["points"] as? List<Map<String, Double>>
      val fillColor = props["fillColor"]?.let { ColorParser.parseColor(it) }
      val strokeColor = props["strokeColor"]?.let { ColorParser.parseColor(it) }
      
      val strokeWidth = (props["strokeWidth"] as? Number)?.toFloat()
      val zIndex = (props["zIndex"] as? Number)?.toFloat()
      
      points?.let {
        val latLngs = it.map { point ->
          val lat = point["latitude"] ?: 0.0
          val lng = point["longitude"] ?: 0.0
          LatLng(lat, lng)
        }
        polygon.points = latLngs
      }
      
      fillColor?.let { polygon.fillColor = it }
      strokeColor?.let { polygon.strokeColor = it }
      strokeWidth?.let { polygon.strokeWidth = it }
      zIndex?.let { polygon.zIndex = it }
    }
  }
  
  /**
   * 清理所有覆盖物
   */
  fun clear() {
    circles.values.forEach { it.remove() }
    circles.clear()
    
    markers.values.forEach { it.remove() }
    markers.clear()
    
    polylines.values.forEach { it.remove() }
    polylines.clear()
    
    polygons.values.forEach { it.remove() }
    polygons.clear()
  }
}
