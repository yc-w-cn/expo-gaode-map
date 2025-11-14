package expo.modules.gaodemap.overlays

import android.content.Context
import android.graphics.Color
import com.amap.api.maps.AMap
import com.amap.api.maps.model.Circle
import com.amap.api.maps.model.CircleOptions
import com.amap.api.maps.model.LatLng
import expo.modules.kotlin.AppContext
import expo.modules.kotlin.viewevent.EventDispatcher
import expo.modules.kotlin.views.ExpoView

class CircleView(context: Context, appContext: AppContext) : ExpoView(context, appContext) {
  
  @Suppress("unused")
  private val onPress by EventDispatcher()
  
  private var circle: Circle? = null
  private var aMap: AMap? = null
  private var center: LatLng? = null
  private var radius: Double = 1000.0
  
  /**
   * 设置地图实例
   */
  @Suppress("unused")
  fun setMap(map: AMap) {
    aMap = map
    // 不立即创建，等 props 设置完成后再创建
  }
  
  /**
   * 设置圆心
   */
  fun setCenter(centerMap: Map<String, Double>) {
    android.util.Log.d("CircleView", "setCenter 被调用: $centerMap")
    val lat = centerMap["latitude"]
    val lng = centerMap["longitude"]
    if (lat != null && lng != null) {
      center = LatLng(lat, lng)
      android.util.Log.d("CircleView", "圆心设置为: lat=$lat, lng=$lng")
      
      // 如果圆形已存在，更新它；否则创建新圆形
      circle?.let {
        android.util.Log.d("CircleView", "更新现有圆形的圆心")
        it.center = center
      } ?: run {
        android.util.Log.d("CircleView", "圆形不存在，尝试创建")
        createOrUpdateCircle()
      }
    }
  }
  
  /**
   * 设置半径
   */
  fun setRadius(radiusValue: Double) {
    radius = radiusValue
    circle?.let {
      it.radius = radius
    }
    // 半径可以后续更新，不需要在这里创建圆形
  }
  
  /**
   * 设置填充颜色
   */
  fun setFillColor(color: Int) {
    circle?.let {
      it.fillColor = color
    }
  }
  
  /**
   * 设置边框颜色
   */
  fun setStrokeColor(color: Int) {
    circle?.let {
      it.strokeColor = color
    }
  }
  
  /**
   * 设置边框宽度
   */
  fun setStrokeWidth(width: Float) {
    circle?.let {
      it.strokeWidth = width
    }
  }
  
  /**
   * 设置 z-index
   */
  fun setZIndex(zIndex: Float) {
    circle?.let {
      it.zIndex = zIndex
    } ?: createOrUpdateCircle()
  }
  
  /**
   * 创建或更新圆形
   */
  private fun createOrUpdateCircle() {
    android.util.Log.d("CircleView", "createOrUpdateCircle 被调用")
    android.util.Log.d("CircleView", "aMap: $aMap, center: $center, radius: $radius")
    
    // 必须同时有地图实例和圆心才能创建
    val map = aMap ?: run {
      android.util.Log.w("CircleView", "⚠️ aMap 为 null，无法创建圆形")
      return
    }
    
    val centerPoint = center ?: run {
      android.util.Log.w("CircleView", "⚠️ center 为 null，无法创建圆形")
      return
    }
    
    if (circle == null) {
      android.util.Log.d("CircleView", "创建新圆形 - center: $centerPoint, radius: $radius")
      val options = CircleOptions()
        .center(centerPoint)
        .radius(radius)
        .fillColor(Color.argb(50, 0, 0, 255))  // 默认半透明蓝色
        .strokeColor(Color.BLUE)                // 默认蓝色边框
        .strokeWidth(10f)                       // 默认边框宽度
      
      circle = map.addCircle(options)
      android.util.Log.d("CircleView", "✅ 圆形创建成功: $circle")
    }
  }
  
  /**
   * 移除圆形
   */
  fun removeCircle() {
    circle?.remove()
    circle = null
  }
  
  override fun onDetachedFromWindow() {
    super.onDetachedFromWindow()
    removeCircle()
  }
}
