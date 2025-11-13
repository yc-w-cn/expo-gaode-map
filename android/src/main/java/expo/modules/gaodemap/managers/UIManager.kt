package expo.modules.gaodemap.managers

import com.amap.api.maps.AMap
import com.amap.api.maps.model.MyLocationStyle

/**
 * UI 和手势管理器
 * 负责地图控件显示、手势控制、图层显示等
 */
class UIManager(private val aMap: AMap) {
  
  // ==================== 控件显示 ====================
  
  /**
   * 设置是否显示缩放控件
   */
  fun setShowsZoomControls(show: Boolean) {
    aMap.uiSettings.isZoomControlsEnabled = show
  }
  
  /**
   * 设置是否显示指南针
   */
  fun setShowsCompass(show: Boolean) {
    aMap.uiSettings.isCompassEnabled = show
  }
  
  /**
   * 设置是否显示比例尺
   */
  fun setShowsScale(show: Boolean) {
    aMap.uiSettings.isScaleControlsEnabled = show
  }
  
  // ==================== 手势控制 ====================
  
  /**
   * 设置是否启用缩放手势
   */
  fun setZoomEnabled(enabled: Boolean) {
    aMap.uiSettings.isZoomGesturesEnabled = enabled
  }
  
  /**
   * 设置是否启用滚动手势
   */
  fun setScrollEnabled(enabled: Boolean) {
    aMap.uiSettings.isScrollGesturesEnabled = enabled
  }
  
  /**
   * 设置是否启用旋转手势
   */
  fun setRotateEnabled(enabled: Boolean) {
    aMap.uiSettings.isRotateGesturesEnabled = enabled
  }
  
  /**
   * 设置是否启用倾斜手势
   */
  fun setTiltEnabled(enabled: Boolean) {
    aMap.uiSettings.isTiltGesturesEnabled = enabled
  }
  
  // ==================== 图层显示 ====================
  
  /**
   * 设置是否显示用户位置
   * @param show 是否显示
   * @param followUserLocation 是否跟随用户位置（默认 false，只显示不移动地图）
   */
  fun setShowsUserLocation(show: Boolean, followUserLocation: Boolean = false) {
    if (show) {
      val myLocationStyle = MyLocationStyle()
      // 根据参数选择定位类型
      val locationType = if (followUserLocation) {
        MyLocationStyle.LOCATION_TYPE_FOLLOW  // 跟随用户位置
      } else {
        MyLocationStyle.LOCATION_TYPE_SHOW    // 只显示，不移动地图
      }
      myLocationStyle.myLocationType(locationType)
      aMap.myLocationStyle = myLocationStyle
      aMap.isMyLocationEnabled = true
    } else {
      aMap.isMyLocationEnabled = false
    }
  }
  
  /**
   * 设置是否显示交通路况
   */
  fun setShowsTraffic(show: Boolean) {
    aMap.isTrafficEnabled = show
  }
  
  /**
   * 设置是否显示建筑物
   */
  fun setShowsBuildings(show: Boolean) {
    aMap.showBuildings(show)
  }
  
  /**
   * 设置是否显示室内地图
   */
  fun setShowsIndoorMap(show: Boolean) {
    aMap.showIndoorMap(show)
  }
  
  /**
   * 设置地图类型
   */
  fun setMapType(type: Int) {
    aMap.mapType = when (type) {
      1 -> AMap.MAP_TYPE_SATELLITE  // 卫星地图
      2 -> AMap.MAP_TYPE_NIGHT      // 夜间地图
      3 -> AMap.MAP_TYPE_NAVI       // 导航地图
      4 -> AMap.MAP_TYPE_BUS        // 公交地图
      else -> AMap.MAP_TYPE_NORMAL  // 标准地图
    }
  }
}
