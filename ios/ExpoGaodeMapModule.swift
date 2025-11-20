import ExpoModulesCore
import AMapFoundationKit
import AMapLocationKit
import MAMapKit

/**
 * 高德地图 Expo 模块
 *
 * 负责:
 * - SDK 初始化和配置
 * - 定位功能管理
 * - 权限管理
 */
public class ExpoGaodeMapModule: Module {
    /// 定位管理器实例
    private var locationManager: LocationManager?
    /// 权限管理器实例
    private var permissionManager: PermissionManager?
    
    public func definition() -> ModuleDefinition {
        Name("ExpoGaodeMap")
        
        // 模块初始化时设置隐私合规
        OnCreate {
            MAMapView.updatePrivacyAgree(AMapPrivacyAgreeStatus.didAgree)
            MAMapView.updatePrivacyShow(AMapPrivacyShowStatus.didShow, privacyInfo: AMapPrivacyInfoStatus.didContain)
        }
        
        // ==================== SDK 初始化 ====================
        
        /**
         * 初始化高德地图 SDK
         * @param config 配置字典,包含 iosKey
         */
        Function("initSDK") { (config: [String: String]) in
            guard let iosKey = config["iosKey"] else { return }
            AMapServices.shared().apiKey = iosKey
            AMapServices.shared().enableHTTPS = true
            self.getLocationManager()
        }
        
        /**
         * 获取 SDK 版本号
         */
        Function("getVersion") {
            "iOS SDK Version"
        }
        
        // ==================== 定位功能 ====================
        
        /**
         * 开始连续定位
         */
        Function("start") {
            self.getLocationManager().start()
        }
        
        /**
         * 停止定位
         */
        Function("stop") {
            self.getLocationManager().stop()
        }
        
        /**
         * 检查是否正在定位
         */
        AsyncFunction("isStarted") { (promise: Promise) in
            promise.resolve(self.getLocationManager().isStarted())
        }
        
        /**
         * 获取当前位置(单次定位)
         * 返回位置信息和逆地理编码结果
         */
        AsyncFunction("getCurrentLocation") { (promise: Promise) in
            let status = CLLocationManager.authorizationStatus()
            
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                let manager = self.getLocationManager()
                manager.locationManager?.requestLocation(withReGeocode: manager.locationManager?.locatingWithReGeocode ?? true, completionBlock: { location, regeocode, error in
                    if let error = error {
                        promise.reject("LOCATION_ERROR", error.localizedDescription)
                        return
                    }
                    
                    guard let location = location else {
                        promise.reject("LOCATION_ERROR", "位置信息为空")
                        return
                    }
                    
                    var locationData: [String: Any] = [
                        "latitude": location.coordinate.latitude,
                        "longitude": location.coordinate.longitude,
                        "accuracy": location.horizontalAccuracy,
                        "altitude": location.altitude,
                        "bearing": location.course,
                        "speed": location.speed,
                        "timestamp": location.timestamp.timeIntervalSince1970 * 1000
                    ]
                    
                    if let regeocode = regeocode {
                        locationData["address"] = regeocode.formattedAddress
                        locationData["province"] = regeocode.province
                        locationData["city"] = regeocode.city
                        locationData["district"] = regeocode.district
                        locationData["street"] = regeocode.street
                        locationData["streetNumber"] = regeocode.number
                        locationData["country"] = regeocode.country
                        locationData["cityCode"] = regeocode.citycode
                        locationData["adCode"] = regeocode.adcode
                    }
                    
                    promise.resolve(locationData)
                })
            } else {
                promise.reject("LOCATION_ERROR", "location unauthorized")
            }
        }
        
        /**
         * 坐标转换
         * iOS 高德地图 SDK 使用 GCJ-02 坐标系,不需要转换
         */
        AsyncFunction("coordinateConvert") { (coordinate: [String: Double], type: Int, promise: Promise) in
            guard let latitude = coordinate["latitude"],
                  let longitude = coordinate["longitude"] else {
                promise.reject("INVALID_ARGUMENT", "无效的坐标参数")
                return
            }
            
            // 高德地图 iOS SDK 使用 GCJ-02 坐标系，不需要转换
            let result: [String: Double] = [
                "latitude": latitude,
                "longitude": longitude
            ]
            promise.resolve(result)
        }
        
        // ==================== 定位配置 ====================
        
        Function("setLocatingWithReGeocode") { (isReGeocode: Bool) in
            self.getLocationManager().setLocatingWithReGeocode(isReGeocode)
        }
        
        Function("setLocationMode") { (_: Int) in
            // iOS 高德 SDK 没有对应的模式设置
        }
        
        Function("setInterval") { (interval: Int) in
            self.getLocationManager().setDistanceFilter(Double(interval))
        }
        
        Function("setLocationTimeout") { (timeout: Int) in
            self.getLocationManager().setLocationTimeout(timeout)
        }
        
        Function("setReGeocodeTimeout") { (timeout: Int) in
            self.getLocationManager().setReGeocodeTimeout(timeout)
        }
        
        Function("setDesiredAccuracy") { (accuracy: Int) in
            self.getLocationManager().setDesiredAccuracy(accuracy)
        }
        
        Function("setPausesLocationUpdatesAutomatically") { (pauses: Bool) in
            self.getLocationManager().setPausesLocationUpdatesAutomatically(pauses)
        }
        
        Function("setAllowsBackgroundLocationUpdates") { (allows: Bool) in
            self.getLocationManager().setAllowsBackgroundLocationUpdates(allows)
        }
        
        Function("startUpdatingHeading") {
            self.getLocationManager().startUpdatingHeading()
        }
        
        Function("stopUpdatingHeading") {
            self.getLocationManager().stopUpdatingHeading()
        }
        
        /**
         * 设置逆地理语言 (iOS 实现)
         */
        Function("setGeoLanguage") { (language: Int) in
            self.getLocationManager().setGeoLanguage(language)
        }
        
        /**
         * 设置是否单次定位 (Android 专用,iOS 空实现)
         */
        Function("setOnceLocation") { (_: Bool) in
            // iOS 不支持此配置
        }
        
        /**
         * 设置是否使用设备传感器 (Android 专用,iOS 空实现)
         */
        Function("setSensorEnable") { (_: Bool) in
            // iOS 不支持此配置
        }
        
        /**
         * 设置是否允许 WIFI 扫描 (Android 专用,iOS 空实现)
         */
        Function("setWifiScan") { (_: Bool) in
            // iOS 不支持此配置
        }
        
        /**
         * 设置是否 GPS 优先 (Android 专用,iOS 空实现)
         */
        Function("setGpsFirst") { (_: Bool) in
            // iOS 不支持此配置
        }
        
        /**
         * 设置是否等待 WIFI 列表刷新 (Android 专用,iOS 空实现)
         */
        Function("setOnceLocationLatest") { (_: Bool) in
            // iOS 不支持此配置
        }
        
        /**
         * 设置是否使用缓存策略 (Android 专用,iOS 空实现)
         */
        Function("setLocationCacheEnable") { (_: Bool) in
            // iOS 不支持此配置
        }
        
        /**
         * 设置网络请求超时时间 (Android 专用,iOS 空实现)
         */
        Function("setHttpTimeOut") { (_: Int) in
            // iOS 不支持此配置
        }
        
        /**
         * 设置定位协议 (未实现)
         */
        Function("setLocationProtocol") { (_: Int) in
            // 未实现
        }
        
        // ==================== 权限管理 ====================
        
        /**
         * 检查位置权限状态
         */
        AsyncFunction("checkLocationPermission") { (promise: Promise) in
            let status = CLLocationManager.authorizationStatus()
            let granted = status == .authorizedAlways || status == .authorizedWhenInUse
            
            promise.resolve([
                "granted": granted,
                "status": self.getAuthorizationStatusString(status)
            ])
        }
        
        /**
         * 请求位置权限
         */
        AsyncFunction("requestLocationPermission") { (promise: Promise) in
            if self.permissionManager == nil {
                self.permissionManager = PermissionManager()
            }
            
            self.permissionManager?.requestPermission { granted, status in
                print("🔐 [PermissionManager] 权限回调: granted=\(granted), status=\(status)")
                
                // 无论结果如何,都延迟后再次检查最终状态
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let finalStatus = CLLocationManager.authorizationStatus()
                    let finalGranted = finalStatus == .authorizedAlways || finalStatus == .authorizedWhenInUse
                    let finalStatusString = self.getAuthorizationStatusString(finalStatus)
                    
                    print("🔐 [PermissionManager] 最终状态: granted=\(finalGranted), status=\(finalStatusString)")
                    
                    promise.resolve([
                        "granted": finalGranted,
                        "status": finalStatusString
                    ])
                }
            }
        }
        
        Events("onHeadingUpdate")
        Events("onLocationUpdate")
        
        OnDestroy {
            self.locationManager?.destroy()
            self.locationManager = nil
        }
    }
    
    // MARK: - 私有方法
    
    /**
     * 获取或创建定位管理器实例
     * 使用懒加载模式,并设置事件回调
     */
    private func getLocationManager() -> LocationManager {
        if locationManager == nil {
            locationManager = LocationManager()
            locationManager?.onLocationUpdate = { [weak self] locationData in
                self?.sendEvent("onLocationUpdate", locationData)
            }
            locationManager?.onHeadingUpdate = { [weak self] headingData in
                self?.sendEvent("onHeadingUpdate", headingData)
            }
        }
        return locationManager!
    }
    
    /**
     * 将权限状态转换为字符串
     */
    private func getAuthorizationStatusString(_ status: CLAuthorizationStatus) -> String {
        switch status {
        case .notDetermined: return "notDetermined"
        case .restricted: return "restricted"
        case .denied: return "denied"
        case .authorizedAlways: return "authorizedAlways"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        @unknown default: return "unknown"
        }
    }
}
