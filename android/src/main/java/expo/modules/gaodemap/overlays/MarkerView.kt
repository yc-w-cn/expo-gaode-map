package expo.modules.gaodemap.overlays

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.view.View
import com.amap.api.maps.AMap
import com.amap.api.maps.model.BitmapDescriptorFactory
import com.amap.api.maps.model.LatLng
import com.amap.api.maps.model.Marker
import com.amap.api.maps.model.MarkerOptions
import expo.modules.kotlin.AppContext
import expo.modules.kotlin.viewevent.EventDispatcher
import expo.modules.kotlin.views.ExpoView

class MarkerView(context: Context, appContext: AppContext) : ExpoView(context, appContext) {
  
  private val onPress by EventDispatcher()
  private val onDragStart by EventDispatcher()
  private val onDrag by EventDispatcher()
  private val onDragEnd by EventDispatcher()
  
  private var marker: Marker? = null
  private var aMap: AMap? = null
  
  /**
   * 设置地图实例
   */
  @Suppress("unused")
  fun setMap(map: AMap) {
    aMap = map
    createOrUpdateMarker()
  }
  
  /**
   * 设置标记位置
   */
  fun setPosition(position: Map<String, Double>) {
    val lat = position["latitude"] ?: return
    val lng = position["longitude"] ?: return
    
    marker?.let {
      it.position = LatLng(lat, lng)
    } ?: createOrUpdateMarker()
  }
  
  /**
   * 设置标题
   */
  fun setTitle(title: String) {
    marker?.let { it.title = title }
  }
  
  /**
   * 设置描述
   */
  fun setDescription(description: String) {
    marker?.let { it.snippet = description }
  }
  
  /**
   * 设置是否可拖拽
   */
  fun setDraggable(draggable: Boolean) {
    marker?.let { it.isDraggable = draggable }
  }
  
  /**
   * 设置是否显示信息窗口
   */
  fun setShowsInfoWindow(show: Boolean) {
    marker?.let {
      if (show) {
        it.showInfoWindow()
      } else {
        it.hideInfoWindow()
      }
    }
  }
  
  /**
   * 设置透明度
   */
  fun setOpacity(opacity: Float) {
    marker?.let { it.alpha = opacity }
  }
  
  /**
   * 设置旋转角度
   */
  fun setMarkerRotation(rotation: Float) {
    marker?.let { it.rotateAngle = rotation }
  }
  
  /**
   * 设置锚点
   */
  @SuppressLint("SuspiciousIndentation")
  fun setAnchor(anchor: Map<String, Float>) {
    val x = anchor["x"] ?: 0.5f
    val y = anchor["y"] ?: 1.0f
      marker?.setAnchor(x, y)
  }
  
  /**
   * 设置是否平贴地图
   */
  fun setFlat(flat: Boolean) {
    marker?.let { it.isFlat = flat }
  }
  
  /**
   * 设置图标
   */
  fun setMarkerIcon(iconUri: String?) {
    iconUri?.let {
      // 这里需要根据 URI 加载图片
      // 可以支持本地资源、网络图片等
      try {
        // 简化处理，实际需要实现图片加载逻辑
        marker?.setIcon(BitmapDescriptorFactory.defaultMarker())
      } catch (e: Exception) {
        e.printStackTrace()
      }
    }
  }
  
  /**
   * 设置 z-index
   */
  fun setZIndex(zIndex: Float) {
    marker?.let { it.zIndex = zIndex }
  }
  
  /**
   * 创建或更新标记
   */
  private fun createOrUpdateMarker() {
    aMap?.let { map ->
      if (marker == null) {
        val options = MarkerOptions()
        marker = map.addMarker(options)
        
        // 设置点击监听
        map.setOnMarkerClickListener { clickedMarker ->
          if (clickedMarker == marker) {
            onPress(mapOf(
              "latitude" to clickedMarker.position.latitude,
              "longitude" to clickedMarker.position.longitude
            ))
            true
          } else {
            false
          }
        }
        
        // 设置拖拽监听
        map.setOnMarkerDragListener(object : AMap.OnMarkerDragListener {
          override fun onMarkerDragStart(draggedMarker: Marker?) {
            if (draggedMarker == marker) {
              draggedMarker?.let {
                onDragStart(mapOf(
                  "latitude" to it.position.latitude,
                  "longitude" to it.position.longitude
                ))
              }
            }
          }
          
          override fun onMarkerDrag(draggedMarker: Marker?) {
            if (draggedMarker == marker) {
              draggedMarker?.let {
                onDrag(mapOf(
                  "latitude" to it.position.latitude,
                  "longitude" to it.position.longitude
                ))
              }
            }
          }
          
          override fun onMarkerDragEnd(draggedMarker: Marker?) {
            if (draggedMarker == marker) {
              draggedMarker?.let {
                onDragEnd(mapOf(
                  "latitude" to it.position.latitude,
                  "longitude" to it.position.longitude
                ))
              }
            }
          }
        })
      }
    }
  }
  
  /**
   * 移除标记
   */
  fun removeMarker() {
    marker?.remove()
    marker = null
  }
  
  override fun onDetachedFromWindow() {
    super.onDetachedFromWindow()
    removeMarker()
  }
}
