import Foundation
import CoreLocation

/**
 * 位置权限管理器
 * 
 * 负责:
 * - 请求位置权限
 * - 监听权限状态变化
 * - 返回权限结果
 */
class PermissionManager: NSObject, CLLocationManagerDelegate {
    /// 位置管理器实例
    private var locationManager: CLLocationManager?
    /// 权限请求回调
    private var permissionCallback: ((Bool, String) -> Void)?
    
    /**
     * 请求位置权限
     * @param callback 权限结果回调 (granted, status)
     */
    func requestPermission(callback: @escaping (Bool, String) -> Void) {
        self.permissionCallback = callback
        
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        }
        
        locationManager?.requestWhenInUseAuthorization()
    }
    
    /**
     * 权限状态变化回调
     */
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        let granted = status == .authorizedAlways || status == .authorizedWhenInUse
        let statusString = getAuthorizationStatusString(status)
        
        permissionCallback?(granted, statusString)
        permissionCallback = nil
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