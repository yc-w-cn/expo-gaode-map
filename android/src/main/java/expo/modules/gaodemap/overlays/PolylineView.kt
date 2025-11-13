package expo.modules.gaodemap.overlays

import android.content.Context
import android.graphics.Color
import com.amap.api.maps.AMap
import com.amap.api.maps.model.LatLng
import com.amap.api.maps.model.Polyline
import com.amap.api.maps.model.PolylineOptions
import expo.modules.kotlin.AppContext
import expo.modules.kotlin.viewevent.EventDispatcher
import expo.modules.kotlin.views.ExpoView

class PolylineView(context: Context, appContext: AppContext) : ExpoView(context, appContext) {
  
  private val onPress by EventDispatcher()
  
  private var polyline: Polyline? = null
  private var aMap: AMap? = null
  private var points: List<LatLng> = emptyList()
  
  /**
   * 设置地图实例
   */
  @Suppress("unused")
  fun setMap(map: AMap) {
    aMap = map
    createOrUpdatePolyline()
  }
  
  /**
   * 设置折线点集合
   */
  fun setPoints(pointsList: List<Map<String, Double>>) {
    points = pointsList.mapNotNull { point ->
      val lat = point["latitude"]
      val lng = point["longitude"]
      if (lat != null && lng != null) {
        LatLng(lat, lng)
      } else null
    }
    polyline?.let {
      it.points = points
    } ?: createOrUpdatePolyline()
  }
  
  /**
   * 设置线宽
   */
  fun setStrokeWidth(width: Float) {
    polyline?.let {
      it.width = width
    } ?: createOrUpdatePolyline()
  }
  
  /**
   * 设置线条颜色
   */
  fun setStrokeColor(color: Int) {
    polyline?.let {
      it.color = color
    } ?: createOrUpdatePolyline()
  }
  
  /**
   * 设置是否虚线
   */
  fun setDashed(dashed: Boolean) {
    polyline?.let {
      it.isDottedLine = dashed
    } ?: createOrUpdatePolyline()
  }
  
  /**
   * 设置是否使用渐变色
   */
  fun setGradient(gradient: Boolean) {
    polyline?.let {
      it.isGeodesic = gradient
    } ?: createOrUpdatePolyline()
  }
  
  /**
   * 设置 z-index
   */
  fun setZIndex(zIndex: Float) {
    polyline?.let {
      it.zIndex = zIndex
    } ?: createOrUpdatePolyline()
  }
  
  /**
   * 设置透明度
   */
  fun setOpacity(opacity: Float) {
    // 通过修改颜色的 alpha 通道实现透明度
    polyline?.let { line ->
      val currentColor = line.color
      val alpha = (opacity * 255).toInt()
      line.color = Color.argb(alpha, Color.red(currentColor), Color.green(currentColor), Color.blue(currentColor))
    }
  }
  
  /**
   * 创建或更新折线
   */
  private fun createOrUpdatePolyline() {
    aMap?.let { map ->
      if (polyline == null && points.isNotEmpty()) {
        val options = PolylineOptions()
          .addAll(points)
          .width(10f)
          .color(Color.BLUE)
        
        polyline = map.addPolyline(options)
        
        // 设置点击监听
        map.setOnPolylineClickListener { clickedPolyline ->
          if (clickedPolyline == polyline) {
            onPress(mapOf("id" to clickedPolyline.id))
          }
        }
      }
    }
  }
  
  /**
   * 移除折线
   */
  fun removePolyline() {
    polyline?.remove()
    polyline = null
  }
  
  override fun onDetachedFromWindow() {
    super.onDetachedFromWindow()
    removePolyline()
  }
}
