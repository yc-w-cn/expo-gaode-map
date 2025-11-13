package expo.modules.gaodemap.modules

import android.content.Context
import android.util.Log
import com.amap.api.location.AMapLocation
import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationClientOption
import com.amap.api.maps.model.LatLng
import expo.modules.kotlin.Promise

/**
 * 定位管理器
 */
class LocationManager(private val context: Context) {
    companion object {
        private const val TAG = "LocationManager"
    }

    private var locationClient: AMapLocationClient? = null
    private var locationOption: AMapLocationClientOption? = null
    private var isLocationStarted = false
    private var onLocationUpdate: ((Map<String, Any?>) -> Unit)? = null

    init {
        initLocationClient()
    }

    /**
     * 设置定位更新回调
     */
    fun setOnLocationUpdate(callback: (Map<String, Any?>) -> Unit) {
        onLocationUpdate = callback
    }

    /**
     * 开始连续定位
     */
    fun start() {
        if (locationClient == null) {
            initLocationClient()
        }
        locationClient?.startLocation()
        isLocationStarted = true
    }

    /**
     * 停止定位
     */
    fun stop() {
        locationClient?.stopLocation()
        isLocationStarted = false
    }

    /**
     * 是否正在定位
     */
    fun isStarted(): Boolean = isLocationStarted

    /**
     * 获取当前位置（单次定位）
     */
    fun getCurrentLocation(promise: Promise) {
        val onceOption = AMapLocationClientOption().apply {
            isOnceLocation = true
            locationOption?.let { opt ->
                locationMode = opt.locationMode
                isNeedAddress = opt.isNeedAddress
                httpTimeOut = opt.httpTimeOut
            }
        }

        val tempClient = AMapLocationClient(context)
        tempClient.setLocationOption(onceOption)
        tempClient.setLocationListener { location ->
            if (location != null && location.errorCode == 0) {
                promise.resolve(formatLocation(location))
            } else {
                promise.reject("LOCATION_ERROR", location?.errorInfo ?: "定位失败", null)
            }
            tempClient.stopLocation()
            tempClient.onDestroy()
        }
        tempClient.startLocation()
    }

    /**
     * 坐标转换
     */
    fun coordinateConvert(
        coordinate: Map<String, Double>,
        type: Int,
        promise: Promise
    ) {
        val lat = coordinate["latitude"] ?: 0.0
        val lng = coordinate["longitude"] ?: 0.0

        try {
            val sourceLatLng = LatLng(lat, lng)
            // 高德 SDK 会自动处理坐标转换
            promise.resolve(
                mapOf(
                    "latitude" to sourceLatLng.latitude,
                    "longitude" to sourceLatLng.longitude
                )
            )
        } catch (e: Exception) {
            promise.reject("CONVERT_ERROR", "坐标转换失败: ${e.message}", e)
        }
    }

    // ==================== 配置方法 ====================

    fun setLocatingWithReGeocode(isReGeocode: Boolean) {
        getOrCreateLocationOption().isNeedAddress = isReGeocode
        applyLocationOption()
    }

    fun setLocationMode(mode: Int) {
        val locationMode = when (mode) {
            1 -> AMapLocationClientOption.AMapLocationMode.Hight_Accuracy
            2 -> AMapLocationClientOption.AMapLocationMode.Battery_Saving
            3 -> AMapLocationClientOption.AMapLocationMode.Device_Sensors
            else -> AMapLocationClientOption.AMapLocationMode.Hight_Accuracy
        }
        getOrCreateLocationOption().locationMode = locationMode
        applyLocationOption()
    }

    fun setInterval(interval: Int) {
        getOrCreateLocationOption().interval = interval.toLong()
        applyLocationOption()
    }

    fun setOnceLocation(isOnceLocation: Boolean) {
        getOrCreateLocationOption().isOnceLocation = isOnceLocation
        applyLocationOption()
    }

    fun setSensorEnable(sensorEnable: Boolean) {
        getOrCreateLocationOption().isSensorEnable = sensorEnable
        applyLocationOption()
    }

    fun setWifiScan(wifiScan: Boolean) {
        getOrCreateLocationOption().isWifiScan = wifiScan
        applyLocationOption()
    }

    fun setGpsFirst(gpsFirst: Boolean) {
        getOrCreateLocationOption().isGpsFirst = gpsFirst
        applyLocationOption()
    }

    fun setOnceLocationLatest(onceLocationLatest: Boolean) {
        getOrCreateLocationOption().isOnceLocationLatest = onceLocationLatest
        applyLocationOption()
    }

    fun setGeoLanguage(language: String) {
        val geoLanguage = when (language) {
            "EN" -> AMapLocationClientOption.GeoLanguage.EN
            "ZH" -> AMapLocationClientOption.GeoLanguage.ZH
            else -> AMapLocationClientOption.GeoLanguage.DEFAULT
        }
        getOrCreateLocationOption().geoLanguage = geoLanguage
        applyLocationOption()
    }

    fun setLocationCacheEnable(locationCacheEnable: Boolean) {
        getOrCreateLocationOption().isLocationCacheEnable = locationCacheEnable
        applyLocationOption()
    }

    fun setHttpTimeOut(httpTimeOut: Int) {
        getOrCreateLocationOption().httpTimeOut = httpTimeOut.toLong()
        applyLocationOption()
    }

    /**
     * 销毁资源
     */
    fun destroy() {
        locationClient?.stopLocation()
        locationClient?.onDestroy()
        locationClient = null
        locationOption = null
    }

    // ==================== 私有方法 ====================

    private fun initLocationClient() {
        if (locationClient == null) {
            locationClient = AMapLocationClient(context).apply {
                setLocationListener { location ->
                    if (location != null && location.errorCode == 0) {
                        onLocationUpdate?.invoke(formatLocation(location))
                    }
                }
            }

            locationOption = AMapLocationClientOption().apply {
                locationMode = AMapLocationClientOption.AMapLocationMode.Hight_Accuracy
                isNeedAddress = true
                interval = 2000
                httpTimeOut = 30000
            }
            locationClient?.setLocationOption(locationOption)
        }
    }

    private fun getOrCreateLocationOption(): AMapLocationClientOption {
        if (locationOption == null) {
            locationOption = AMapLocationClientOption()
        }
        return locationOption!!
    }

    private fun applyLocationOption() {
        locationClient?.setLocationOption(locationOption)
    }

    private fun formatLocation(location: AMapLocation): Map<String, Any?> {
        return mapOf(
            "latitude" to location.latitude,
            "longitude" to location.longitude,
            "altitude" to location.altitude,
            "accuracy" to location.accuracy,
            "heading" to location.bearing,
            "speed" to location.speed,
            "timestamp" to location.time,
            "address" to location.address,
            "country" to location.country,
            "province" to location.province,
            "city" to location.city,
            "district" to location.district,
            "cityCode" to location.cityCode,
            "adCode" to location.adCode,
            "street" to location.street,
            "streetNumber" to location.streetNum,
            "poiName" to location.poiName,
            "aoiName" to location.aoiName,
            "description" to location.locationDetail,
            "coordType" to location.coordType,
            "buildingId" to location.buildingId
        )
    }
}
