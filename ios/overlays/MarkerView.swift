import ExpoModulesCore
import MAMapKit

/**
 * 标记点视图
 * 
 * 负责:
 * - 在地图上显示标记点
 * - 管理标记点属性(位置、标题、描述)
 * - 支持拖拽功能
 */
class MarkerView: ExpoView {
    /// 标记点位置
    var position: [String: Double] = [:]
    /// 标题
    var title: String = ""
    /// 描述
    var markerDescription: String = ""
    /// 是否可拖拽
    var draggable: Bool = false
    
    /// 地图视图弱引用
    private var mapView: MAMapView?
    /// 标记点对象
    private var annotation: MAPointAnnotation?
    
    required init(appContext: AppContext? = nil) {
        super.init(appContext: appContext)
    }
    
    /**
     * 设置地图实例
     * @param map 地图视图
     */
    func setMap(_ map: MAMapView) {
        self.mapView = map
        updateAnnotation()
    }
    
    /**
     * 更新标记点
     */
    private func updateAnnotation() {
        guard let mapView = mapView,
              let latitude = position["latitude"],
              let longitude = position["longitude"] else {
            return
        }
        
        // 移除旧的标记
        if let oldAnnotation = annotation {
            mapView.removeAnnotation(oldAnnotation)
        }
        
        // 创建新的标记
        let annotation = MAPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = title
        annotation.subtitle = markerDescription
        
        mapView.addAnnotation(annotation)
        self.annotation = annotation
    }
    
    /**
     * 设置位置
     * @param position 位置坐标 {latitude, longitude}
     */
    func setPosition(_ position: [String: Double]) {
        self.position = position
        updateAnnotation()
    }
    
    /**
     * 设置标题
     * @param title 标题文本
     */
    func setTitle(_ title: String) {
        self.title = title
        updateAnnotation()
    }
    
    /**
     * 设置描述
     * @param description 描述文本
     */
    func setDescription(_ description: String) {
        self.markerDescription = description
        updateAnnotation()
    }
    
    /**
     * 设置是否可拖拽
     * @param draggable 是否可拖拽
     */
    func setDraggable(_ draggable: Bool) {
        self.draggable = draggable
        // iOS 高德地图标记默认不可拖拽，需要自定义实现
    }
    
    /**
     * 析构时移除标记点
     */
    deinit {
        if let mapView = mapView, let annotation = annotation {
            mapView.removeAnnotation(annotation)
        }
    }
}
