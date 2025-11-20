import ExpoModulesCore
import MAMapKit

/**
 * 标记点视图
 *
 * 负责:
 * - 在地图上显示标记点
 * - 管理标记点属性(位置、标题、描述)
 * - 支持拖拽功能
 * - 支持自定义 children 视图
 */
class MarkerView: ExpoView {
    // MARK: - 事件派发器
    let onPress = EventDispatcher()
    let onDragStart = EventDispatcher()
    let onDrag = EventDispatcher()
    let onDragEnd = EventDispatcher()
    
    /// 标记点位置
    var position: [String: Double] = [:]
    /// 标题
    var title: String = ""
    /// 描述
    var markerDescription: String = ""
    /// 是否可拖拽
    var draggable: Bool = false
    /// 图标 URI
    var iconUri: String?
    /// 图标宽度
    var iconWidth: Double = 40
    /// 图标高度
    var iconHeight: Double = 40
    /// 中心偏移
    var centerOffset: [String: Double]?
    /// 是否显示动画
    var animatesDrop: Bool = false
    /// 大头针颜色
    var pinColor: String = "red"
    /// 是否显示气泡
    var canShowCallout: Bool = true
    
    /// 地图视图弱引用
    private var mapView: MAMapView?
    /// 标记点对象
    var annotation: MAPointAnnotation?
    /// 标记点视图
    private var annotationView: MAAnnotationView?
    
    required init(appContext: AppContext? = nil) {
        super.init(appContext: appContext)
        // 不可交互,通过父视图定位到屏幕外
        isUserInteractionEnabled = false
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
        
        // 延迟处理子视图,等待 React Native 添加完成
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            if let view = mapView.view(for: annotation), self.subviews.count > 0 {
                self.annotationView = view
                if let image = self.createImageFromSubviews() {
                    view.image = image
                    view.centerOffset = CGPoint(x: 0, y: -image.size.height / 2)
                }
            }
        }
    }
    
    /**
     * 将子视图转换为图片
     */
    private func createImageFromSubviews() -> UIImage? {
        guard subviews.count > 0 else { return nil }
        
        // 强制布局
        setNeedsLayout()
        layoutIfNeeded()
        
        let size = bounds.size
        guard size.width > 0 && size.height > 0 else { return nil }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        
        // 当添加子视图时,更新标记图标
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.subviews.count > 0, let view = self.annotationView {
                if let image = self.createImageFromSubviews() {
                    view.image = image
                    view.centerOffset = CGPoint(x: 0, y: -image.size.height / 2)
                }
            }
        }
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
        updateAnnotation()
    }
    
    func setIcon(_ source: [String: Any]?) {
        if let dict = source {
            // 处理 require() 返回的对象
            if let uri = dict["uri"] as? String {
                self.iconUri = uri
            }
        }
        updateAnnotation()
    }
    
    func setCenterOffset(_ offset: [String: Double]) {
        self.centerOffset = offset
    }
    
    func setAnimatesDrop(_ animate: Bool) {
        self.animatesDrop = animate
    }
    
    func setPinColor(_ color: String) {
        self.pinColor = color
    }
    
    func setCanShowCallout(_ show: Bool) {
        self.canShowCallout = show
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
